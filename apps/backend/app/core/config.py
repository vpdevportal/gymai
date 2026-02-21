from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )

    app_name: str = "gymai-backend"
    debug: bool = True
    allowed_origins: list[str] = ["http://localhost:3000", "http://localhost:8080"]

    # Database
    database_url: str = "sqlite:///./gymai.db"

    # Auth
    secret_key: str = "change-me-in-production"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30


settings = Settings()
