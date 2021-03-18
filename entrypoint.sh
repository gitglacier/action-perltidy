#!/bin/bash

cd ${GITHUB_WORKSPACE}

perltidybackupext="perltidybak"
returnresult=0
echo "[*] Running PerlTidy"
while read perlfile; do
  echo " === Running perlTidy against \"$perlfile\"..."
  perltidy -pbp -w -npro -l=160 -i=3 -ci=3 -nt -vmll -asc -dsm -bbs -msc=1 -novalign -vt=0 -nbbc -pt=0 -nst -b -bext="/${perltidybackupext}" "$perlfile"
  perltidyresult=$?
  if [ "$perltidyresult" -ne "0" ]; then
    returnresult="$perltidyresult";
    echo " [!] Return result $perltidyresult caught, We will signal to Github that this run was not successful."
  fi
  perlfilelog="${perlfile}.LOG"
  perlfilebackup="${perlfile}.${perltidybackupext}"
  if [ -f "${perlfilebackup}" ]; then
    echo " [!] Issue Detected during perlTidy run requiring file restore!"
    if [ -f "${perlfilelog}" ]; then
      echo "PerlTidy Log Output: ";
      cat "$perlfilelog";
      rm -fv "$perlfilelog";
    else
      echo "  !! PerlTidy did not report log output but had an error, This is odd. Please manually run perltidy on this file."
    fi
    echo "Restoring Backup file due to errors"
    mv -fv "${perlfilebackup}" "${perlfile}"
  fi
done < <(git diff --name-only origin/master | grep -P "(\.pl|\.pm|\.cgi)$")
exit $returnresult
