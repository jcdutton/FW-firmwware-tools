echo -off

for %i in 0 1 2 3 4 5 6 7 8 9 A B C D E F

if exist FS%i:\EFI\ectool\Startup.nsh then
FS%i:
endif

endfor

cd EFI\ectool
echo "Dropping to prompt"
