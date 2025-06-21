from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime


class UserBase(BaseModel):
    username: str = Field(..., max_length=50)
    email: EmailStr
    age: Optional[int] = Field(None, gt=0, lt=130)
    weight: Optional[float] = Field(None, gt=0)
    height: Optional[float] = Field(None, gt=0)
    fitness_goal: Optional[str] = None
    profile_picture: Optional[str] = None  # URL or base64 string

    class Config:
        orm_mode = True


class RegisterRequest(UserBase):
    password: str = Field(..., min_length=6)


class UpdateProfileRequest(BaseModel):
    username: Optional[str] = Field(None, max_length=50)
    email: Optional[EmailStr] = None
    password: Optional[str] = Field(None, min_length=6)
    age: Optional[int] = Field(None, gt=0, lt=130)
    weight: Optional[float] = Field(None, gt=0)
    height: Optional[float] = Field(None, gt=0)
    fitness_goal: Optional[str] = None
    profile_picture: Optional[str] = None


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class UserResponse(UserBase):
    id: int


class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse


class WorkoutBase(BaseModel):
    workout_type: str = Field(..., max_length=100)
    duration_minutes: float = Field(..., gt=0)
    calories_burned: float = Field(..., gt=0)

    class Config:
        orm_mode = True


class WorkoutCreate(WorkoutBase):
    pass


class WorkoutResponse(WorkoutBase):
    id: int
    timestamp: datetime


class MealBase(BaseModel):
    meal_type: str = Field(..., max_length=100)
    calories: float = Field(..., gt=0)
    carbs: float = Field(..., ge=0)
    protein: float = Field(..., ge=0)
    fat: float = Field(..., ge=0)

    class Config:
        orm_mode = True


class MealCreate(MealBase):
    pass


class MealResponse(MealBase):
    id: int
    timestamp: datetime
