# foreach ($i in $(cat .\ci-dk.txt)) { wget "https://barcodegenerator.online/barcode.asp?bc1=$i&bc2=30&bc3=1&bc4=1&bc5=1&bc6=1&bc7=Arial&bc8=15&bc9=2" -OutFile "$i.png" }

param([string]$text)

if ($text -ne "") {
	Write-Output " - Getting $text"
	Invoke-WebRequest "https://barcodegenerator.online/barcode.asp?bc1=$text&bc2=30&bc3=1&bc4=1&bc5=1&bc6=1&bc7=Arial&bc8=15&bc9=2" -OutFile "dist/$text.png"
}
else {


	$lines = ""
	$n = 0

	$type = ""
	$number = ""

	mkdir -Force "dist"
	foreach ($line in $(Get-Content "tags-datamatrix-id.txt")) {
		# Loop only on odds
		$loop = $n % 2
		if ($loop -eq 0) {
			$type = $line
		}
		else {
			$number = $line
			Write-Output "Type : $type" "Number : $number"
			for ($i = 1; $i -le $number; $i++) {
				$number_format = "{0:d3}" -f $i
				$id = "CI-$type-$number_format"

				Write-Output " - Getting $id"
				Invoke-WebRequest "https://barcodegenerator.online/barcode.asp?bc1=$id&bc2=30&bc3=1&bc4=1&bc5=1&bc6=1&bc7=Arial&bc8=15&bc9=2" -OutFile "dist/$id.png"

			}
		}

		$n = $n + 1
	}
	Write-Output $lines
}