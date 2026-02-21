from fastapi import APIRouter
from pydantic import BaseModel, EmailStr

router = APIRouter()


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


@router.post("/login", response_model=TokenResponse)
async def login(body: LoginRequest) -> TokenResponse:
    # TODO: validate credentials against DB and return JWT
    raise NotImplementedError("Auth not implemented yet")


@router.post("/logout")
async def logout() -> dict[str, str]:
    # TODO: invalidate token / blacklist
    return {"message": "logged out"}


@router.get("/me")
async def me() -> dict[str, str]:
    # TODO: return current user from JWT
    raise NotImplementedError("Auth not implemented yet")
