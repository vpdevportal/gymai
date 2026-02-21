# GymAI - Pricing & Cost Estimation

## Overview

This document provides detailed pricing information for the recommended tech stack for GymAI, with a focus on Supabase as the primary backend service.

---

## 1. Supabase Pricing

### 1.1 Pricing Plans

#### Free Plan
- **Cost:** $0/month
- **Authentication:** Up to 50,000 Monthly Active Users (MAUs)
- **Database Storage:** 500 MB
- **File Storage:** 1 GB
- **Bandwidth:** 5 GB/month
- **Features:**
  - Unlimited API requests
  - Community support
  - 7-day backup retention

**Best for:** MVP, development, testing, initial launch (0-1,000 users)

#### Pro Plan
- **Cost:** $25/month
- **Authentication:** Up to 100,000 MAUs
- **Database Storage:** 8 GB
- **File Storage:** 100 GB
- **Bandwidth:** 250 GB/month
- **Features:**
  - Everything in Free plan
  - Daily backups (7-day retention)
  - Email support
  - Point-in-time recovery
  - Custom domains

**Best for:** Growth phase (1,000-50,000 users)

#### Team Plan
- **Cost:** $599/month
- **Authentication:** Up to 100,000 MAUs
- **Database Storage:** 8 GB
- **File Storage:** 100 GB
- **Bandwidth:** 250 GB/month
- **Features:**
  - Everything in Pro plan
  - Priority support
  - Team collaboration tools
  - SOC 2 compliance
  - Daily backups (28-day retention)

**Best for:** Large scale (50,000+ users) or enterprise needs

#### Enterprise Plan
- **Cost:** Custom pricing
- **Authentication:** Unlimited MAUs
- **Database Storage:** Custom allocations
- **File Storage:** Custom allocations
- **Bandwidth:** Custom allocations
- **Features:**
  - Everything in Team plan
  - Dedicated support
  - Custom SLA
  - On-premise deployment option
  - Custom integrations

**Best for:** Enterprise customers with specific requirements

### 1.2 Overage Costs

If you exceed the included limits in your plan:

- **Database Storage:** $0.125 per GB per day (billed daily)
- **File Storage:** $0.021 per GB per month
- **Bandwidth (Egress):** $0.09 per GB (after included limit)
- **Additional MAUs:** Not applicable (limits are hard caps on Free/Pro/Team plans)

---

## 2. Cost Estimates for GymAI by Phase

### Phase 1: MVP (0-1,000 users)
**Recommended Plan: Free**

**Estimated Usage:**
- **Users:** 500-1,000 MAUs (well under 50K limit)
- **Database:** 50-100 MB
  - User profiles: ~5 KB × 1,000 = 5 MB
  - Workout plans: ~10 KB × 100 = 1 MB
  - Exercise library: ~50 KB × 500 = 25 MB
  - Workout logs: ~2 KB × 10,000 = 20 MB
  - Progress data: ~1 KB × 10,000 = 10 MB
- **Storage:** 500 MB - 1 GB
  - Profile photos: ~200 KB × 1,000 = 200 MB
  - Progress photos: ~500 KB × 1,000 = 500 MB

**Monthly Cost:** $0

---

### Phase 2: Early Growth (1,000-10,000 users)
**Recommended Plan: Pro ($25/month)**

**Estimated Usage:**
- **Users:** 5,000-10,000 MAUs (under 100K limit)
- **Database:** 500 MB - 2 GB
  - User profiles: ~5 KB × 10,000 = 50 MB
  - Workout plans: ~10 KB × 1,000 = 10 MB
  - Exercise library: ~50 KB × 1,000 = 50 MB
  - Workout logs: ~2 KB × 100,000 = 200 MB
  - Progress data: ~1 KB × 100,000 = 100 MB
  - Social data: ~5 KB × 50,000 = 250 MB
- **Storage:** 10-20 GB
  - Profile photos: ~200 KB × 10,000 = 2 GB
  - Progress photos: ~500 KB × 20,000 = 10 GB
  - Exercise videos: ~5 MB × 500 = 2.5 GB

**Monthly Cost:** $25/month (likely no overages)

---

### Phase 3: Scaling (10,000-50,000 users)
**Recommended Plan: Pro ($25/month) + minimal overages**

**Estimated Usage:**
- **Users:** 20,000-50,000 MAUs (under 100K limit)
- **Database:** 2-5 GB
  - User profiles: ~5 KB × 50,000 = 250 MB
  - Workout plans: ~10 KB × 5,000 = 50 MB
  - Exercise library: ~50 KB × 2,000 = 100 MB
  - Workout logs: ~2 KB × 500,000 = 1 GB
  - Progress data: ~1 KB × 500,000 = 500 MB
  - Social data: ~5 KB × 500,000 = 2.5 GB
- **Storage:** 30-60 GB
  - Profile photos: ~200 KB × 50,000 = 10 GB
  - Progress photos: ~500 KB × 100,000 = 50 GB
  - Exercise videos: ~5 MB × 1,000 = 5 GB

**Monthly Cost:** $25/month + ~$5-10/month overages = **$30-35/month**

**Overage Breakdown:**
- Database: 0-2 GB over 8 GB = $0-62.50/month (if exceeded)
- Storage: 0-10 GB over 100 GB = $0-0.21/month (if exceeded)
- Bandwidth: Minimal (within 250 GB limit)

---

### Phase 4: Large Scale (50,000+ users)
**Recommended Plan: Team ($599/month) or Enterprise**

**Estimated Usage:**
- **Users:** 50,000+ MAUs
- **Database:** 5-8 GB+
- **Storage:** 60-100 GB+
- **Bandwidth:** 250 GB+

**Monthly Cost:** $599/month (Team) or custom pricing (Enterprise)

---

## 3. Additional Service Costs

### 3.1 Analytics Service

#### Mixpanel
- **Free:** Up to 20M events/month
- **Growth:** $25/month (100M events/month)
- **Enterprise:** Custom pricing

#### Amplitude
- **Free:** 10M events/month
- **Plus:** $995/month (100M events/month)
- **Enterprise:** Custom pricing

#### PostHog (Recommended for cost-effectiveness)
- **Free:** 1M events/month
- **Startup:** $0/month (self-hosted option)
- **Cloud:** $0.000225 per event (pay-as-you-go)

**Estimated Cost for GymAI:**
- MVP: $0 (PostHog free tier)
- Growth: $0-25/month (PostHog or Mixpanel)
- Scale: $25-100/month

---

### 3.2 Crash Reporting

#### Sentry
- **Developer:** $0/month (5K events/month)
- **Team:** $26/month (50K events/month)
- **Business:** $80/month (500K events/month)

**Estimated Cost for GymAI:**
- MVP: $0 (free tier)
- Growth: $26/month
- Scale: $26-80/month

---

### 3.3 Push Notifications

#### Expo Notifications (Recommended)
- **Cost:** Free (included with Expo)
- **Limitations:** Works with Expo projects only

#### OneSignal
- **Free:** Up to 10,000 subscribers
- **Growth:** $9/month (10K-100K subscribers)
- **Scale:** $99/month (100K-1M subscribers)

**Estimated Cost for GymAI:**
- MVP: $0 (Expo Notifications)
- Growth: $0-9/month
- Scale: $9-99/month

---

### 3.4 AI/ML Services

#### On-Device ML (TensorFlow Lite / Core ML)
- **Cost:** Free (runs on device)
- **No cloud costs for form checking**

#### Cloud ML (for recommendations)
- **AWS SageMaker:** Pay-per-use (~$0.10-1.00 per 1,000 predictions)
- **Google Cloud ML:** Pay-per-use (~$0.10-1.00 per 1,000 predictions)
- **Custom ML Service:** Varies based on infrastructure

**Estimated Cost for GymAI:**
- MVP: $0 (on-device only)
- Growth: $10-50/month (cloud ML for recommendations)
- Scale: $50-200/month

---

## 4. Total Cost Estimates

### Year 1 Cost Projection

#### Scenario A: Slow Growth (1,000 users by end of year)
- **Months 1-6:** Free plan = $0/month
- **Months 7-12:** Pro plan = $25/month
- **Additional Services:** ~$30/month (analytics, crash reporting, notifications)
- **Total Year 1:** ~$330

#### Scenario B: Moderate Growth (10,000 users by end of year)
- **Months 1-3:** Free plan = $0/month
- **Months 4-12:** Pro plan = $25/month
- **Additional Services:** ~$50/month
- **Total Year 1:** ~$600

#### Scenario C: Fast Growth (50,000 users by end of year)
- **Months 1-2:** Free plan = $0/month
- **Months 3-9:** Pro plan = $25/month
- **Months 10-12:** Pro plan + overages = $35/month
- **Additional Services:** ~$100/month
- **Total Year 1:** ~$1,200

---

## 5. Cost Comparison: Supabase vs Firebase

### Supabase
- **Free tier:** 50K MAUs, 500 MB DB, 1 GB storage
- **Pro:** $25/month fixed (100K MAUs, 8 GB DB, 100 GB storage)
- **Predictable pricing**
- **Better value at scale**

### Firebase
- **Free tier:** 50K MAUs, 1 GB storage, 10 GB database
- **Blaze (Pay-as-you-go):**
  - Auth: $0.0055 per MAU after 50K
  - Firestore: $0.18 per GB storage, $0.06 per 100K reads
  - Storage: $0.026 per GB
- **Variable pricing can get expensive**

**Example for 10,000 users:**
- **Supabase:** $25/month (fixed)
- **Firebase:** ~$30-50/month (variable, depends on reads/writes)

**Example for 50,000 users:**
- **Supabase:** $25-35/month (with minimal overages)
- **Firebase:** ~$100-200/month (variable costs add up)

---

## 6. Cost Optimization Strategies

### 6.1 Image Optimization
- **Compress images before upload:** Reduce storage by 70-80%
- **Use WebP format:** Better compression than JPEG
- **Progressive loading:** Load images on-demand
- **CDN for videos:** Use Cloudflare or similar (cheaper than Supabase storage for large files)

**Savings:** Can reduce storage costs by 50-70%

### 6.2 Database Optimization
- **Archive old workout data:** Move inactive data to cold storage
- **Use efficient indexes:** Reduce query costs
- **Implement pagination:** Limit data retrieval
- **Cache frequently accessed data:** Reduce database reads

**Savings:** Can reduce database size by 30-50%

### 6.3 Bandwidth Optimization
- **Use CDN for static assets:** Reduce egress costs
- **Implement caching:** Reduce API calls
- **Compress API responses:** Reduce data transfer
- **Progressive data loading:** Load only what's needed

**Savings:** Can reduce bandwidth costs by 40-60%

### 6.4 Smart Feature Implementation
- **Lazy load social features:** Only load when needed
- **Batch API requests:** Reduce number of calls
- **Use real-time subscriptions efficiently:** Only subscribe to necessary data
- **Implement offline-first:** Reduce API calls when offline

---

## 7. Recommended Plan by User Count

| User Count | Recommended Plan | Monthly Cost | Notes |
|-----------|------------------|--------------|-------|
| 0-1,000 | Free | $0 | Perfect for MVP |
| 1,000-10,000 | Pro | $25 | Great value, no overages |
| 10,000-50,000 | Pro + overages | $30-40 | Still cost-effective |
| 50,000+ | Team | $599 | Enterprise features needed |

---

## 8. Additional Considerations

### 8.1 Hidden Costs
- **Development time:** Not included in service costs
- **Third-party integrations:** Some may have costs
- **App store fees:** $99/year (Apple), $25 one-time (Google)
- **Domain and SSL:** ~$10-20/year (if using custom domain)

### 8.2 Scaling Considerations
- **Monitor usage regularly:** Track database, storage, and bandwidth
- **Set up alerts:** Get notified before hitting limits
- **Plan for growth:** Upgrade plan before hitting limits
- **Optimize early:** Implement best practices from the start

### 8.3 Budget Planning
- **MVP Phase (Months 1-3):** $0-50/month
- **Growth Phase (Months 4-12):** $50-100/month
- **Scale Phase (Year 2+):** $100-700/month

---

## 9. Summary

### Key Takeaways
1. **Start with Free plan:** Perfect for MVP and initial development
2. **Pro plan is excellent value:** $25/month handles up to 50K users effectively
3. **Predictable costs:** Supabase offers better cost predictability than Firebase
4. **Optimize early:** Image compression and database optimization save money
5. **Total first-year cost:** Estimated $300-1,200 depending on growth

### Recommended Stack Costs (Monthly)
- **Supabase:** $0-35/month (depending on phase)
- **Analytics (PostHog/Mixpanel):** $0-25/month
- **Crash Reporting (Sentry):** $0-26/month
- **Push Notifications (Expo):** $0/month
- **AI/ML (On-device + Cloud):** $0-50/month
- **Total:** $0-136/month (MVP to Growth phase)

This pricing structure makes GymAI very cost-effective for a startup, with the ability to scale efficiently as the user base grows.

---

**Last Updated:** 2024  
**Note:** Pricing is subject to change. Always check official Supabase pricing page for the most current information.

