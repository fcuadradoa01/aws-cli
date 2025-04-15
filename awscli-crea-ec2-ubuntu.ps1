#=================
# Paco Cuadrado fcuadradoa01@educantabria.es
# v1.0 - 2025-04-15
# Descripción: Crea una instancia EC2 basada en Ubuntu 24.0
# Powershell version: 5.1
#=================
# paso de parametros:
param (
    [Parameter(Mandatory=$true)]
    [string]$Nombre,
    [Parameter(Mandatory=$true)]
    [string]$VpcId,
    [Parameter(Mandatory=$true)]
    [string]$SubredIdPublica
)

# Configurar la región
$region = "us-east-1"
# Configura tus variables
$instanceType = "t2.micro"  # apto para la capa gratuita
$keyName = "vockey"  # Por Defecto
$Amiid = "ami-04b4f1a9cf54c11d0" # Ubuntu Server 24.04 x64

# Crea el grupo de seguridad
Write-Host "==10: crea el grupo-de-seguridad"
$securityGroupId = aws ec2 create-security-group `
    --group-name "$Nombre-sg" `
    --description "Grupo de seguridad que abre el puerto 22" `
    --region $region `
    --vpc-id $vpcId `
    --query 'GroupId' `
    --output text

# Configura las reglas del grupo de seguridad
Write-Host "==11: abro el puerto 22"
aws ec2 authorize-security-group-ingress `
    --group-id $securityGroupId `
    --region $region `
    --protocol tcp `
    --port 22 `
    --cidr 0.0.0.0/0 `
    --output text

# Crea la instancia EC2
Write-Host "==21: Lanzo la EC2"
$instanceId = aws ec2 run-instances `
    --image-id $amiId `
    --instance-type $instanceType `
    --region $region `
    --key-name $keyName `
    --security-group-ids $securityGroupId `
    --subnet-id $SubredIdPublica `
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$Nombre}]" `
    --associate-public-ip-address `
    --count 1 `
    --query 'Instances[0].InstanceId' `
    --output text

# Muestra el ID de la instancia creada
Write-Host "===== IaC: EC2 Ubunutu 24.04 ==========="
Write-Host "secury-group ID: $securityGroupId"
Write-Output "Instancia EC2 ID: $instanceId"