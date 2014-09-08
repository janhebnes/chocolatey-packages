try{
  Remove-BinFile 'Sudo' '..\lib\Sudo.1.0\bin\sudo.cmd'
  Generate-BinFile 'Sudo' '..\lib\Sudo.1.0.1\bin\sudo.cmd'
  Write-ChocolateySuccess 'sudo'
} catch {
  Write-ChocolateyFailure 'sudo' "$($_.Exception.Message)"
  throw 
}
