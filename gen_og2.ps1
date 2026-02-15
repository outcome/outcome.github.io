Add-Type -AssemblyName System.Drawing
function New-Og([string]$out,[string]$title,[string]$hex,[string]$icon){
  $w=1200; $h=630
  $bmp=New-Object System.Drawing.Bitmap $w,$h
  $g=[System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode='AntiAlias'
  $g.TextRenderingHint='AntiAliasGridFit'

  $bg=[System.Drawing.Color]::FromArgb(3,3,8)
  $accent=[System.Drawing.ColorTranslator]::FromHtml($hex)
  $rect=New-Object System.Drawing.Rectangle 0,0,$w,$h
  $grad=New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect,$bg,$bg,0
  $blend=New-Object System.Drawing.Drawing2D.ColorBlend
  $blend.Colors=@([System.Drawing.Color]::FromArgb(5,5,10),[System.Drawing.Color]::FromArgb([int]($accent.R*0.22),[int]($accent.G*0.22),[int]($accent.B*0.22)),[System.Drawing.Color]::FromArgb(5,5,10))
  $blend.Positions=@(0.0,0.55,1.0)
  $grad.InterpolationColors=$blend
  $g.FillRectangle($grad,$rect)

  # subtle glow left
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddEllipse(-220,80,760,760)
  $pBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($path)
  $pBrush.CenterColor = [System.Drawing.Color]::FromArgb(55,$accent.R,$accent.G,$accent.B)
  $pBrush.SurroundColors = @([System.Drawing.Color]::FromArgb(0,0,0,0))
  $g.FillPath($pBrush,$path)

  $white=[System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
  $titleFont=New-Object System.Drawing.Font('Arial',102,[System.Drawing.FontStyle]::Bold)

  $left=90; $cy=315; $textX=320
  if($icon -and (Test-Path $icon)){
    $img=[System.Drawing.Image]::FromFile($icon)
    $th=190; $tw=[int]($img.Width*$th/$img.Height)
    $x=$left; $y=[int](($h-$th)/2)
    $g.DrawImage($img,$x,$y,$tw,$th)
    $textX=$x+$tw+55
    $img.Dispose()
  } else {
    $pts=@([System.Drawing.PointF]::new(130,240),[System.Drawing.PointF]::new(195,315),[System.Drawing.PointF]::new(130,390),[System.Drawing.PointF]::new(165,425),[System.Drawing.PointF]::new(275,315),[System.Drawing.PointF]::new(165,205))
    $g.FillPolygon($white,$pts)
  }

  $g.DrawString($title,$titleFont,$white,$textX,220)
  $bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)

  $titleFont.Dispose();$white.Dispose();$pBrush.Dispose();$path.Dispose();$grad.Dispose();$g.Dispose();$bmp.Dispose()
}
New-Item -ItemType Directory -Path outcome.github.io/media/og -Force | Out-Null
New-Og 'outcome.github.io/media/og/main.png' 'OUTCOME' '#1f1f2b' ''
New-Og 'outcome.github.io/media/og/purityguard.png' 'PURITY GUARD' '#6b21a8' 'outcome.github.io/media/PurityGuard/PurityIcon.png'
New-Og 'outcome.github.io/media/og/relayai.png' 'RELAY AI' '#444450' 'outcome.github.io/media/RelayAI/RelayIcon.png'
New-Og 'outcome.github.io/media/og/scraper.png' 'STEAM SCRAPER' '#2563eb' ''
