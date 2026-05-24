# Architecture

This document describes the target architecture for the interview exercise.

## Level 1

```
Internet
    │
    ▼
Lambda Function ──── IAM Execution Role
                         └── AWSLambdaBasicExecutionRole
                         └── AWSLambdaVPCAccessExecutionRole
    │
    ▼ (VPC)
┌─────────────────────────────────────┐
│  VPC  10.0.0.0/16                   │
│                                     │
│  ┌──────────────┐  ┌─────────────┐  │
│  │ Public       │  │ Public      │  │
│  │ Subnet AZ-a  │  │ Subnet AZ-b │  │
│  │ 10.0.1.0/24  │  │ 10.0.2.0/24 │  │
│  └──────────────┘  └─────────────┘  │
│         IGW attached to VPC         │
│  ┌──────────────┐  ┌─────────────┐  │
│  │ Private      │  │ Private     │  │
│  │ Subnet AZ-a  │  │ Subnet AZ-b │  │
│  │ 10.0.11.0/24 │  │10.0.12.0/24 │  │
│  │              │  │             │  │
│  │  Lambda Fn   │  │             │  │
│  └──────────────┘  └─────────────┘  │
└─────────────────────────────────────┘
```

## Level 2 (extends Level 1)

```
Internet
    │
    ▼
API Gateway (REST API)
    │
    ▼ (invoke_arn + Lambda permission)
Lambda Function  [Level 1 VPC config unchanged]
```
