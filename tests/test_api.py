import pytest
from api.api import api

@pytest.fixture
def client():
    api.testing = True
    with api.test_client() as client:
        yield client

def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.data.decode("utf-8") == "OK"
