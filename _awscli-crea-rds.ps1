#=================
# Paco Cuadrado fcuadradoa01@educantabria.es
# v1.0 - 2025-04-15
# Descripción: Crea una instancia RDS MySQL
# Powershell version: 5.1
#=================
# paso de parametros:
param (
    [Parameter(Mandatory=$true)]
    [string]$Nombre,
    [Parameter(Mandatory=$true)]
    [string]$VpcId
)

# Configurar la región
$region = "us-east-1"
# bloque CIDR subredes 
$bloque_subred_privada5 = "10.10.5.0/24"
$bloque_subred_privada6 = "10.10.6.0/24"
$bloque_subred_privada7 = "10.10.7.0/24"
$bloque_subred_privada8 = "10.10.8.0/24"


# Configura tus variables
$dbInstanceIdentifier = "mi-rds-mysql"
$dbInstanceClass = "db.t4g.micro" # 2vCPU 1Gib RAM
$engine = "mysql"
$masterUsername = "admin"
$masterUserPassword = "Password1"
$dbName = "miBaseDeDatos"
$allocatedStorage = 20  # Tamaño del almacenamiento en GB
$vpcSecurityGroupId = "sg-0d6457664d0c5b1d8"  # Reemplaza con tu grupo de seguridad

# Crear la subred privada
Write-Host "==10: crea Subred Privada 5"
$privateSubnetId5 = (aws ec2 create-subnet `
    --vpc-id $vpcId `
    --cidr-block $bloque_subred_privada5 `
    --region $region --availability-zone "us-east-1a" `
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=subred5-privada}]' `
    --query 'Subnet.SubnetId' --output text)

Write-Host "==11: crea Subred Privada 6"
$privateSubnetId6 = (aws ec2 create-subnet `
    --vpc-id $vpcId `
    --cidr-block $bloque_subred_privada6 `
    --region $region --availability-zone "us-east-1a" `
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=subred6-privada}]' `
    --query 'Subnet.SubnetId' --output text)

Write-Host "==12: crea Subred Privada 7"
$privateSubnetId7 = (aws ec2 create-subnet `
    --vpc-id $vpcId `
    --cidr-block $bloque_subred_privada7 `
    --region $region --availability-zone "us-east-1a" `
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=subred7-privada}]' `
    --query 'Subnet.SubnetId' --output text)

Write-Host "==13: crea Subred Privada 8"
$privateSubnetId8 = (aws ec2 create-subnet `
    --vpc-id $vpcId `
    --cidr-block $bloque_subred_privada8 `
    --region $region --availability-zone "us-east-1a" `
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=subred8-privada}]' `
    --query 'Subnet.SubnetId' --output text)

Write-Host "==20: crea el Grupo-Subredes"
$GrupoSubred = (aws rds create-db-subnet-group `
    --db-subnet-group-name mydbsubnetgroup  `
    --db-subnet-group-description "My DB Subnet Group" `
    --subnet-ids $privateSubnetId5 $privateSubnetId6 $privateSubnetId7 $privateSubnetId8 `
    -- query 'dbSubnetGroup.Id' --output text)

Write-Host "==30: crea el RDS"
# Crea la instancia RDS
aws rds create-db-instance `
    --db-instance-identifier $dbInstanceIdentifier `
    --db-instance-class $dbInstanceClass `
    --engine $engine `
    --master-username $masterUsername `
    --master-user-password $masterUserPassword `
    --allocated-storage $allocatedStorage `
    --db-name $dbName `
    --region $region `
    --db-subnet-group-name $GrupoSubred `
    --backup-retention-period 7 `
    --no-multi-az `
    --publicly-accessible `
    --query 'DBInstance.DBInstanceIdentifier' `
    --output text

# Muestra el ID de la instancia RDS creada
Write-Output "Instancia RDS creada con ID: $dbInstanceIdentifier"