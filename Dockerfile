FROM python:3.12-slim

WORKDIR /app

# 시스템 의존성 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Poetry 설치
RUN pip install --no-cache-dir poetry==1.6.1

# Poetry 설정: 가상환경 생성하지 않음
RUN poetry config virtualenvs.create false

# 프로젝트 의존성 파일 복사
COPY pyproject.toml poetry.lock* ./

# 의존성 설치
RUN poetry install --without dev --no-interaction --no-ansi

# 애플리케이션 코드 복사
COPY . .

# 환경 변수 설정
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# 포트 노출
EXPOSE 8000

# 실행 명령
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"] 