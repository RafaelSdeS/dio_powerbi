# Executa 01_schema.sql, 02_dados.sql e as verificações no MySQL da Azure.
# Rode no PowerShell, dentro desta pasta:  .\executar_na_azure.ps1
# A senha é digitada no prompt, não é salva em arquivo nem aparece na tela.

$mysql = "C:\Program Files\MySQL\MySQL Server 9.1\bin\mysql.exe"
if (-not (Test-Path $mysql)) { $mysql = "mysql" }   # usa o mysql do PATH se o caminho acima não existir

$servidor = Read-Host "Servidor (ex.: meu-servidor.mysql.database.azure.com)"
$usuario  = Read-Host "Usuário administrador"
$senhaSeg = Read-Host "Senha" -AsSecureString
$senha    = [System.Net.NetworkCredential]::new("", $senhaSeg).Password

$env:MYSQL_PWD = $senha        # variável só desta sessão; evita a senha na linha de comando
try {
    foreach ($arquivo in "01_schema.sql", "02_dados.sql", "03_verificacoes.sql") {
        Write-Host "`n>>> $arquivo" -ForegroundColor Cyan
        Get-Content -Raw -Encoding UTF8 (Join-Path $PSScriptRoot $arquivo) |
            & $mysql --host=$servidor --user=$usuario --ssl-mode=REQUIRED --default-character-set=utf8mb4 --table
        if ($LASTEXITCODE -ne 0) { throw "Falha ao executar $arquivo" }
    }
    Write-Host "`nConcluído. Confira: use azure_company; select count(*) from employee;  (esperado: 8)" -ForegroundColor Green
}
finally {
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
}
