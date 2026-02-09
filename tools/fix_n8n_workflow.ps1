param(
  [Parameter(Mandatory = $true)]
  [string]$InputPath,
  [string]$OutputPath
)

if (-not (Test-Path -LiteralPath $InputPath)) {
  Write-Error "Input file not found: $InputPath"; exit 1
}

try {
  $wf = Get-Content -Raw -LiteralPath $InputPath | ConvertFrom-Json -ErrorAction Stop
} catch {
  Write-Error "Failed to parse JSON from ${InputPath}: $($_.Exception.Message)"; exit 1
}

# Ensure nodes array exists
if (-not $wf.nodes) {
  Write-Error "No 'nodes' array found in workflow JSON."; exit 1
}

$httpNodesFixed = 0
foreach ($n in $wf.nodes) {
  if ($n.type -eq 'n8n-nodes-base.httpRequest') {
    if (-not $n.parameters) { $n | Add-Member -NotePropertyName parameters -NotePropertyValue (@{}) }

    # Ensure HTTP method is explicitly set. Some n8n versions expect a string and may lowercase it.
    $hasMethodKey = $n.parameters.PSObject.Properties.Name -contains 'method'
    $methodVal = if ($hasMethodKey) { [string]$n.parameters.method } else { '' }
    if (-not $hasMethodKey -or [string]::IsNullOrWhiteSpace($methodVal)) {
      if ($hasMethodKey) {
        $n.parameters.method = 'GET'
      } else {
        $n.parameters | Add-Member -NotePropertyName method -NotePropertyValue 'GET'
      }
      $httpNodesFixed++
    }

    # Ensure authentication field is present; default to 'none' when not provided
    $hasAuthKey = $n.parameters.PSObject.Properties.Name -contains 'authentication'
    $authVal = if ($hasAuthKey) { [string]$n.parameters.authentication } else { '' }
    if (-not $hasAuthKey -or [string]::IsNullOrWhiteSpace($authVal)) {
      if ($hasAuthKey) {
        $n.parameters.authentication = 'none'
      } else {
        $n.parameters | Add-Member -NotePropertyName authentication -NotePropertyValue 'none'
      }
    }
  }
}

$outPath = if ($OutputPath) { $OutputPath } else { "$InputPath.fixed.json" }

try {
  $json = $wf | ConvertTo-Json -Depth 100
  Set-Content -LiteralPath $outPath -Encoding UTF8 -NoNewline -Value $json
} catch {
  Write-Error "Failed to write fixed workflow JSON: $($_.Exception.Message)"; exit 1
}

Write-Host "Fixed $httpNodesFixed HTTP Request node(s). Output: $outPath"
