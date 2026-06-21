@echo off
chcp 65001 >nul
title 四柱排盘工具

echo ========================================
echo   四柱排盘 · 一键启动
echo ========================================
echo.

cd /d "%~dp0"

echo 正在启动本地服务器...
echo 启动后请访问: http://localhost:8080
echo 按 Ctrl+C 停止服务器
echo.

python -m http.server 8080

if errorlevel 1 (
    echo.
    echo 未检测到 Python，尝试使用 PowerShell...
    powershell -Command "$listener = [System.Net.HttpListener]::new(); $listener.Prefixes.Add('http://localhost:8080/'); $listener.Start(); Write-Host '服务器已启动: http://localhost:8080'; while ($listener.IsListening) { $context = $listener.GetContext(); $file = Join-Path $PWD.Path ($context.Request.Url.LocalPath -replace '/','\'); if ($context.Request.Url.LocalPath -eq '/') { $file = Join-Path $PWD.Path 'index.html' }; if (Test-Path $file) { $bytes = [IO.File]::ReadAllBytes($file); $context.Response.ContentType = 'text/html'; $context.Response.OutputStream.Write($bytes, 0, $bytes.Length) } else { $context.Response.StatusCode = 404 }; $context.Response.Close() }"
)
