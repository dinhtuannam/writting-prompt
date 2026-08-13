$directory = Join-Path $PSScriptRoot 'story-3/chapters'

Get-ChildItem -LiteralPath $directory -File -Filter 'chapter-*.md' | ForEach-Object {
    $lines = [System.IO.File]::ReadAllLines($_.FullName, [System.Text.UTF8Encoding]::new($false)) |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ }

    if ($lines.Count -lt 3) { return }

    $output = [System.Collections.Generic.List[string]]::new()
    $output.Add('# ' + $lines[0] + ' ' + $lines[1])
    $output.Add('')

    $paragraph = [System.Text.StringBuilder]::new()
    for ($i = 2; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -eq '***') {
            if ($paragraph.Length -gt 0) { $output.Add($paragraph.ToString()); $output.Add(''); $paragraph.Clear() | Out-Null }
            $output.Add('***'); $output.Add('')
            continue
        }

        if ($paragraph.Length -gt 0) {
            $previous = $paragraph.ToString()
            # A sentence ending at a PDF line boundary is the strongest
            # available signal for the start of a new paragraph.
            if ($previous -match '[.!?…](?:["”’»]+)?$') {
                $output.Add($previous)
                $output.Add('')
                $paragraph.Clear() | Out-Null
            } else {
                $paragraph.Append(' ') | Out-Null
            }
        }
        $paragraph.Append($line) | Out-Null
    }
    if ($paragraph.Length -gt 0) { $output.Add($paragraph.ToString()) }

    while ($output.Count -gt 0 -and -not $output[$output.Count - 1]) { $output.RemoveAt($output.Count - 1) }
    [System.IO.File]::WriteAllText($_.FullName, ($output -join "`r`n") + "`r`n", [System.Text.UTF8Encoding]::new($false))
}
