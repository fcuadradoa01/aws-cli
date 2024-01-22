#!/bin/bash

#-------------
# fcuadradoa01
# enero-2024
#-------------
# Crear VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.10.0.0/16 --query 'Vpc.{VpcId:VpcId}' --output text)

# Crear subred pública
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.10.100.0/24 --query 'Subnet.{SubnetId:SubnetId}' --output text)

# Crear subred privada
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.10.101.0/24 --query 'Subnet.{SubnetId:SubnetId}' --output text)

# Crear Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' --output text)

# Adjuntar Internet Gateway al VPC
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID

# Crear una tabla de rutas para la subred pública
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.{RouteTableId:RouteTableId}' --output text)

# Asociar la tabla de rutas con la subred pública
aws ec2 associate-route-table --subnet-id $PUBLIC_SUBNET_ID --route-table-id $ROUTE_TABLE_ID

# Crear una ruta hacia Internet Gateway en la tabla de rutas
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID

echo "VPC, subredes y gateway creados con éxito."