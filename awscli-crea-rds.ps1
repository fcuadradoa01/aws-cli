# Configura tus variables
$dbInstanceIdentifier = "mi-rds-mysql"
$dbInstanceClass = "db.t4g.micro"
$engine = "mysql"
$masterUsername = "admin"
$masterUserPassword = "P@ssword"
$dbName = "miBaseDeDatos"
$allocatedStorage = 20  # Tamaño del almacenamiento en GB
$vpcSecurityGroupId = "sg-xxxxxxxx"  # Reemplaza con tu grupo de seguridad

# Crea la instancia RDS
aws rds create-db-instance `
    --db-instance-identifier $dbInstanceIdentifier `
    --db-instance-class $dbInstanceClass `
    --engine $engine `
    --master-username $masterUsername `
    --master-user-password $masterUserPassword `
    --allocated-storage $allocatedStorage `
    --db-name $dbName `
    --vpc-security-group-ids $vpcSecurityGroupId `
    --backup-retention-period 7 `
    --no-multi-az `
    --publicly-accessible `
    --query 'DBInstance.DBInstanceIdentifier' `
    --output text

# Muestra el ID de la instancia RDS creada
Write-Output "Instancia RDS creada con ID: $dbInstanceIdentifier"