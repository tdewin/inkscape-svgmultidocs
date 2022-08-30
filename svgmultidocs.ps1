param(
    $out=".\out",
    $fname=@("svgmultidoc")
)

if (-not (Test-Path -Path $out -PathType Container)) {
    new-item -Type Directory -Path $out
}
$height = 1080
$width = 1920

$template=@"
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Created with Inkscape (http://www.inkscape.org/) -->

<svg
   width="{0}"
   height="{1}"
   viewBox="0 0 {0} {1}"
   version="1.1"
   id="svg39377"
   inkscape:version="1.2.1 (9c6d41e410, 2022-07-14)"
   sodipodi:docname="multidoc-vertical.svg"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">
  <sodipodi:namedview
     id="namedview39379"
     pagecolor="#ffffff"
     bordercolor="#666666"
     borderopacity="1.0"
     inkscape:showpageshadow="2"
     inkscape:pageopacity="0.0"
     inkscape:pagecheckerboard="0"
     inkscape:deskcolor="#d1d1d1"
     inkscape:document-units="px"
     showgrid="false"
     inkscape:zoom="0.5"
     inkscape:cx="1100"
     inkscape:cy="500"
     inkscape:window-width="1920"
     inkscape:window-height="1009"
     inkscape:window-x="-8"
     inkscape:window-y="-8"
     inkscape:window-maximized="1"
     inkscape:current-layer="layer1">
    {2}
  </sodipodi:namedview>
  <defs
     id="defs39374" />
  <g
     inkscape:label="Layer 1"
     inkscape:groupmode="layer"
     id="layer1" />
</svg>
"@ 

$pagemulti = @"
<inkscape:page id="page-{0}" x="{1}" y="{2}" width="{3}" height="{4}" />
"@



function ConvertTo-DotDecimal { param($n) return $n.ToString("f",[System.Globalization.CultureInfo]::GetCultureInfo("en-us")) }
Set-Alias -Name c -Value ConvertTo-DotDecimal


foreach ($multidoccount in (1..100)) {
    foreach ($orientation in @("vertical","horizontal")) {
        $stack = @()
        foreach ($p in (0..($multidoccount-1))) { 
            if ($orientation -eq "vertical") {
                $stack += ($pagemulti -f ($p+1),0,(c ($height*$p)),(c $width),(c $height))
            } else {
                $stack += ($pagemulti -f ($p+1),(c ($width*$p)),0,(c $width),(c $height))
            }
            
        }
        $fnamenew = $fname.Clone()
        $fnamenew += $orientation
        $fnamenew += $multidoccount
        $fnamenew += "svg"
    
        ($template -f $width,$height,($stack -join "`n")) | Set-Content (Join-Path -Path $out -ChildPath ($fnamenew -join "."))
    }
}


