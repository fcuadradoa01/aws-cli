#=================
# Paco Cuadrado fcuadradoa01@educantabria.es
# 2025-03-07
# Powershell version: 5.1
# Descripción: Crea un VPC con sus subredes asociadas, igw, igwNAT y rutas
#=================
# Configurar la región
$region = "us-east-1"
#
# Configura tus variables
$amiId = "ami-04b4f1a9cf54c11d0" # Ubuntu Server 24.04 x64
$instanceType = "t2.micro"  # Puedes cambiar el tipo de instancia según tus necesidades
$keyName = "vockey"  # Por Defecto
$vpcId = "vpc-06ef719da1858e528"
$subnetId = "subnet-09414bd20207949c3"

# Crea el grupo de seguridad
Write-Host "==10: crea el grupo-de-seguridad"
$securityGroupId = aws ec2 create-security-group `
    --group-name "lapolla57-sg" `
    --description "Grupo de seguridad que abre los puertos 22 y 80" `
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

Write-Host "==11: abro el puerto 80"
aws ec2 authorize-security-group-ingress `
    --group-id $securityGroupId `
    --region $region `
    --protocol tcp `
    --port 80 `
    --cidr 0.0.0.0/0 `
    --output text

# Crea la instancia EC2
Write-Host "==20: Lanzo la EC2"
$instanceId = aws ec2 run-instances `
    --image-id $amiId `
    --instance-type $instanceType `
    --region $region `
    --key-name $keyName `
    --security-group-ids $securityGroupId `
    --subnet-id $subnetId `
    --associate-public-ip-address `
    --count 1 `
    --query 'Instances[0].InstanceId' `
    --output text

# Muestra el ID de la instancia creada
Write-Host "===== IaC ==========="
Write-Host "secury-group ID: $securityGroupId"
Write-Output "Instancia EC2 ID: $instanceId"