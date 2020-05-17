@PowerShell -ExecutionPolicy Bypass -Command Invoke-Expression $('$args=@(^&{$args} %*);'+[String]::Join(';',(Get-Content '%~f0') -notmatch '^^@PowerShell.*EOF$')) & goto :EOF

echo "        /######                                     /##    /##/##             "
echo "       /##__  ##                                   | ##   | #|__/             "
echo "      | ##  \__/ /######  /######  /####### /######| ##   | ##/##/######/#### "
echo "      |  ###### /##__  ##|____  ##/##_____//##__  #|  ## / ##| #| ##_  ##_  ##"
echo "       \____  #| ##  \ ## /######| ##     | ########\  ## ##/| #| ## \ ## \ ##"
echo "       /##  \ #| ##  | ##/##__  #| ##     | ##_____/ \  ###/ | #| ## | ## | ##"
echo "      |  ######| #######|  ######|  ######|  #######  \  #/  | #| ## | ## | ##"
echo "       \______/| ##____/ \_______/\_______/\_______/   \_/   |__|__/ |__/ |__/"
echo "               | ##                                                           "
echo "               | ##                                                           "
echo "               |__/                                                           "
echo "                    �汾 : 1.1.0-dev  ���Ĺ��� : https://spacevim.org/cn/     "

Push-Location ~

$app_name    = "SpaceVim"
$repo_url    = "https://github.com/SpaceVim/SpaceVim.git"
$repo_name   = "SpaceVim"
$repo_path   = "$HOME\.SpaceVim"

Function Pause ($Message = "�밴���ⰴ������ . . . ") {
  if ((Test-Path variable:psISE) -and $psISE) {
    $Shell = New-Object -ComObject "WScript.Shell"
      $Button = $Shell.Popup("Click OK to continue.", 0, "Script Paused", 0)
  } else {     
    Write-Host -NoNewline $Message
      [void][System.Console]::ReadKey($true)
      Write-Host
  }
}

echo "==> ��ʼ��⻷������..."
echo ""
sleep 1


echo "==> ���� git ����"
if (Get-Command "git" -ErrorAction SilentlyContinue) {
  git version
  echo "[OK] ���Գɹ�. ��ʼ��һ������..."
  sleep 1
} else {
  echo ""
  echo "[ERROR] �޷������ PATH �з��� 'git.exe' ����"
  echo ">>> ׼���˳�......"
  Pause
  exit
}

echo ""

echo "==> ���� gvim ����"
if (Get-Command "gvim" -ErrorAction SilentlyContinue) {
  echo ($(vim --version) -split '\n')[0]
  echo "[OK] ���Գɹ�. ��ʼ��һ������..."
  sleep 1
} else {
  echo "[WARNING] �޷������ PATH �з��� 'gvim.exe' ����. ���Կɼ�����װ..."
  echo ""
  echo "[WARNING] �������װ gvim ������ȷ������� PATH! "
  Pause
}

echo "<== ����������������. ������һ��..."
sleep 1
echo ""
echo ""

if (!(Test-Path "$HOME\.SpaceVim")) {
  echo "==> ���ڰ�װ $app_name"
  git clone $repo_url $repo_path
} else {
  echo "==> ���ڸ��� $app_name"
  Push-Location $repo_path
  git pull origin master
}

echo ""
if (!(Test-Path "$HOME\vimfiles")) {
  cmd /c mklink $HOME\vimfiles $repo_path
  echo "[OK] ��Ϊ vim ��װ SpaceVim"
  sleep 1
} else {
  echo "[OK] $HOME\vimfiles �Ѵ���"
  sleep 1
}

echo ""
if (!(Test-Path "$HOME\AppData\Local\nvim")) {
  cmd /c mklink "$HOME\AppData\Local\nvim" $repo_path
  echo "[OK] ��Ϊ neovim ��װ SpaceVim"
  sleep 1
} else {
  echo "[OK] $HOME\AppData\Local\nvim �Ѵ���"
  sleep 1
}

echo ""
echo "��װ�����!"
echo "=============================================================================="
echo "==               �� Vim �� Neovim�����в�������Զ���װ                   =="
echo "=============================================================================="
echo ""
echo "��л֧�� SpaceVim����ӭ������"
echo ""

Pause

# vim:set ft=ps1 nowrap: 
