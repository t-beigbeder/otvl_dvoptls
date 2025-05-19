from pydantic import BaseModel


class Host(BaseModel):
    name: str
    password: str


class Secret(BaseModel):
    key: str
    value: str
