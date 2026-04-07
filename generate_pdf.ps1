$outputPath = "C:\Users\Lenovo\Documents\New project\app_summary.pdf"

function Escape-PdfText {
    param([string]$Text)
    return $Text.Replace("\", "\\").Replace("(", "\(").Replace(")", "\)")
}

$lines = @(
    @{ text = "App Summary"; x = 50; y = 800; size = 20; leading = 0 },
    @{ text = "Repo evidence source: C:\Users\Lenovo\Documents\New project"; x = 50; y = 784; size = 9; leading = 0 },
    @{ text = "Generated on 2026-03-19"; x = 50; y = 772; size = 9; leading = 0 },

    @{ text = "WHAT IT IS"; x = 50; y = 742; size = 12; leading = 0 },
    @{ text = "This workspace contains no application source files, configuration, documentation, or assets."; x = 50; y = 726; size = 10; leading = 0 },
    @{ text = "Based on current repo evidence, the app itself is Not found in repo."; x = 50; y = 712; size = 10; leading = 0 },

    @{ text = "WHO IT'S FOR"; x = 50; y = 686; size = 12; leading = 0 },
    @{ text = "Primary user/persona: Not found in repo."; x = 50; y = 670; size = 10; leading = 0 },
    @{ text = "No README, product brief, UI copy, or requirements were present to identify a target user."; x = 50; y = 656; size = 10; leading = 0 },

    @{ text = "WHAT IT DOES"; x = 50; y = 630; size = 12; leading = 0 },
    @{ text = "- Application purpose: Not found in repo"; x = 58; y = 614; size = 10; leading = 0 },
    @{ text = "- User-facing features: Not found in repo"; x = 58; y = 600; size = 10; leading = 0 },
    @{ text = "- Backend or API capabilities: Not found in repo"; x = 58; y = 586; size = 10; leading = 0 },
    @{ text = "- Data model or storage behavior: Not found in repo"; x = 58; y = 572; size = 10; leading = 0 },
    @{ text = "- Authentication or permissions: Not found in repo"; x = 58; y = 558; size = 10; leading = 0 },
    @{ text = "- Integrations or third-party services: Not found in repo"; x = 58; y = 544; size = 10; leading = 0 },

    @{ text = "HOW IT WORKS"; x = 50; y = 516; size = 12; leading = 0 },
    @{ text = "- Observed component: repository root only"; x = 58; y = 500; size = 10; leading = 0 },
    @{ text = "- Observed contents: no files and no subfolders"; x = 58; y = 486; size = 10; leading = 0 },
    @{ text = "- No README, package manifest, source tree, build config, or deployment files found"; x = 58; y = 472; size = 10; leading = 0 },
    @{ text = "- Architecture, services, and data flow: Not found in repo"; x = 58; y = 458; size = 10; leading = 0 },

    @{ text = "HOW TO RUN"; x = 50; y = 430; size = 12; leading = 0 },
    @{ text = "1. Open C:\Users\Lenovo\Documents\New project"; x = 58; y = 414; size = 10; leading = 0 },
    @{ text = "2. Inspect the repo contents"; x = 58; y = 400; size = 10; leading = 0 },
    @{ text = "3. Current result: no runnable app files were found, so startup steps are Not found in repo."; x = 58; y = 386; size = 10; leading = 0 },

    @{ text = "EVIDENCE CHECKED"; x = 50; y = 358; size = 12; leading = 0 },
    @{ text = "- Root directory listing showed only . and .."; x = 58; y = 342; size = 10; leading = 0 },
    @{ text = "- No repository files were available to infer stack, runtime, or behavior"; x = 58; y = 328; size = 10; leading = 0 },
    @{ text = "- Summary intentionally avoids assumptions beyond those observations"; x = 58; y = 314; size = 10; leading = 0 }
)

$contentBuilder = New-Object System.Text.StringBuilder
[void]$contentBuilder.AppendLine("0.12 0.16 0.20 rg")

foreach ($line in $lines) {
    $escaped = Escape-PdfText $line.text
    [void]$contentBuilder.AppendLine("BT /F1 $($line.size) Tf 1 0 0 1 $($line.x) $($line.y) Tm ($escaped) Tj ET")
}

$streamText = $contentBuilder.ToString()
$streamBytes = [System.Text.Encoding]::ASCII.GetBytes($streamText)
$streamLength = $streamBytes.Length

$objects = New-Object System.Collections.Generic.List[string]
$objects.Add("<< /Type /Catalog /Pages 2 0 R >>")
$objects.Add("<< /Type /Pages /Kids [3 0 R] /Count 1 >>")
$objects.Add("<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 5 0 R >> >> /Contents 4 0 R >>")
$objects.Add("<< /Length $streamLength >>`nstream`n$streamText`nendstream")
$objects.Add("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>")

$builder = New-Object System.Text.StringBuilder
[void]$builder.Append("%PDF-1.4`n")

$offsets = New-Object System.Collections.Generic.List[int]
for ($i = 0; $i -lt $objects.Count; $i++) {
    $offsets.Add([System.Text.Encoding]::ASCII.GetByteCount($builder.ToString()))
    [void]$builder.Append("$($i + 1) 0 obj`n")
    [void]$builder.Append($objects[$i])
    [void]$builder.Append("`nendobj`n")
}

$xrefOffset = [System.Text.Encoding]::ASCII.GetByteCount($builder.ToString())
[void]$builder.Append("xref`n")
[void]$builder.Append("0 $($objects.Count + 1)`n")
[void]$builder.Append("0000000000 65535 f `n")
foreach ($offset in $offsets) {
    [void]$builder.Append(("{0:0000000000} 00000 n `n" -f $offset))
}
[void]$builder.Append("trailer`n")
[void]$builder.Append("<< /Size $($objects.Count + 1) /Root 1 0 R >>`n")
[void]$builder.Append("startxref`n")
[void]$builder.Append("$xrefOffset`n")
[void]$builder.Append("%%EOF")

[System.IO.File]::WriteAllBytes($outputPath, [System.Text.Encoding]::ASCII.GetBytes($builder.ToString()))
Write-Output "Created $outputPath"
