#=================
# Paco Cuadrado fcuadradoa01@educantabria.es
# v1.0 - 2025-04-15
# Descripción: Crea una instancia EC2 basada en Windows Server 2025
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
$instanceType = "t3.small"  # 2vCPU 2GB RAM
$keyName = "vockey"  # Por Defecto
$Amiid = "ami-02e3d076cbd5c28fa" # Windows Server 2025

# Crea el grupo de seguridad
Write-Host "==10: crea el grupo-de-seguridad"
$securityGroupId = aws ec2 create-security-group `
    --group-name "$Nombre-sg" `
    --description "Grupo de seguridad que abre el puerto 3389 RPD" `
    --region $region `
    --vpc-id $vpcId `
    --query 'GroupId' `
    --output text

# Configura las reglas del grupo de seguridad
Write-Host "==11: abro el puerto 3389 - RDP"
aws ec2 authorize-security-group-ingress `
    --group-id $securityGroupId `
    --region $region `
    --protocol tcp `
    --port 3389 `
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
Write-Host "===== IaC: EC2 Windows Sever 2025 ==========="
Write-Host "secury-group ID: $securityGroupId"
Write-Output "Instancia EC2 ID: $instanceId"