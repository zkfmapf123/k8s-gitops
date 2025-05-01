#!/bin/bash

# AWS 계정 ID와 리전 설정
AWS_ACCOUNT_ID="your-aws-account-id"
AWS_REGION="ap-northeast-2"
ECR_REPOSITORY="payment-api"
IMAGE_TAG="latest"

# ECR 로그인
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Buildx 빌더 생성 (없는 경우)
docker buildx create --use --name multiarch-builder

# 이미지 빌드 및 푸시
docker buildx build \
  --platform linux/arm64 \
  -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG} \
  --push \
  ./services/payment-api 