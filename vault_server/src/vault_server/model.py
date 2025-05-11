from pydantic import BaseModel


class Host(BaseModel):
    name: str


class Secret(BaseModel):
    key: str
    value: str
