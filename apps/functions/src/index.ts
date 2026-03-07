import * as logger from "firebase-functions/logger";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineString } from "firebase-functions/params";
import OpenAI from "openai";

// Read the API Key securely from Firebase parameters or environment variables
// It's recommended to deploy this using Firebase Secrets, but an env param works too.
const openaiApiKey = defineString("OPENAI_API_KEY");

export const generateWorkoutPlan = onCall(async (request) => {
    // Ensure the user is authenticated (optional, depends on your use case)
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "The function must be called while authenticated."
        );
    }

    const {
        age,
        weight,
        height,
        gender,
        activity_level,
        goal,
        days_per_week = 4,
        experience_level = "Beginner",
    } = request.data;

    // Validate critical inputs
    if (!goal) {
        throw new HttpsError("invalid-argument", "The 'goal' must be provided.");
    }

    const apiKey = openaiApiKey.value();
    if (!apiKey) {
        logger.error("OPENAI_API_KEY is not defined");
        throw new HttpsError("internal", "Server configuration error.");
    }

    const openai = new OpenAI({ apiKey });

    const systemPrompt = `You are an expert personal trainer. Generate a highly effective, customized workout plan based on the user's profile and goals. Output the plan in strict JSON format. Make sure your response matches this JSON structure exactly:
  {
    "planName": "...",
    "description": "...",
    "days": [
      {
        "day": "...",
        "focus": "...",
        "exercises": [
          { "name": "...", "sets": 3, "reps": "10-12", "rest": "60 sec", "notes": "..." }
        ]
      }
    ]
  }`;

    const userPrompt = `
    User Profile:
    - Age: ${age}
    - Gender: ${gender}
    - Weight: ${weight} kg
    - Height: ${height} cm
    - Activity Level: ${activity_level}
    
    Goals:
    - Primary Goal: ${goal}
    - Experience Level: ${experience_level}
    - Preferred Days per Week: ${days_per_week}

    Please provide a ${days_per_week}-day workout plan. Include exercises, sets, reps, and brief instructions.
  `;

    try {
        const response = await openai.chat.completions.create({
            model: "gpt-4o-mini",
            response_format: { type: "json_object" },
            messages: [
                { role: "system", "content": systemPrompt },
                { role: "user", "content": userPrompt },
            ],
            temperature: 0.7,
        });

        const content = response.choices[0]?.message?.content;
        if (!content) {
            throw new Error("No content received from OpenAI");
        }

        const data = JSON.parse(content);
        return data;
    } catch (error) {
        logger.error("Failed to generate workout plan", error);
        throw new HttpsError("internal", "Failed to generate workout plan from AI.");
    }
});
