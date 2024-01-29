#!/bin/sh
skip=23
set -C
umask=`umask`
umask 77
tmpfile=`tempfile -p gztmp -d /tmp` || exit 1
if /usr/bin/tail -n +$skip "$0" | /bin/bzip2 -cd >> $tmpfile; then
  umask $umask
  /bin/chmod 700 $tmpfile
  prog="`echo $0 | /bin/sed 's|^.*/||'`"
  if /bin/ln -T $tmpfile "/tmp/$prog" 2>/dev/null; then
    trap '/bin/rm -f $tmpfile "/tmp/$prog"; exit $res' 0
    (/bin/sleep 5; /bin/rm -f $tmpfile "/tmp/$prog") 2>/dev/null &
    /tmp/"$prog" ${1+"$@"}; res=$?
  else
    trap '/bin/rm -f $tmpfile; exit $res' 0
    (/bin/sleep 5; /bin/rm -f $tmpfile) 2>/dev/null &
    $tmpfile ${1+"$@"}; res=$?
  fi
else
  echo Cannot decompress $0; exit 1
fi; exit $res
BZh91AY&SYz��  �_�E����/nޮ����    @۳m
ҀhI��S'�6P�!�hѦ�P���4�2@q�&��LFF�!�4i�1  ���2i�4DmF��@ 4��C�� �B4� ��� �14�z�4��d��	��-'�jet�YV2�6�=ZXʢ�\4�[gg4��,�$��`�W��tdrS�qk�0f���M�	B�;T�ɟ��%����N#��[0Ya� �4&	fD6���ACD/�o6m�<�%�ڛsܒ��Y�7T�R�6ܠ
%-P����|t�2�\��y畫��~o4\���m�z1k܀���d�{&�4���^숹5G�R�xW��wĶ�i��q���]�rK7+���DHa'�������77~�)�I�`��Fl1/�������x@�nh"�dj���C9�Q���5���0���tt��X�W2C8w��Pc�p�^��h���Y����E+_t�ҍ(0�0r�3ݜ\Ʌ��T����8�2�e�ɞ�O���zOv���5°fA�m��1"r,��	 ��T�c>b�1:hP�t��텑_�:z�*,���l�ˎ�&��J-��vc�n5=By���f�ћov(�S,by��m���aܮ\�! %�`�� �� D�\�aLZ�\p����i$��)��HZu������z�V+S�����J=�[M�i���hXcUƲ�*������.���3�����6P��ϩ�%��đ�{LC��&A���pȶ	�3q�g�R��I�2��&Y�3��$��	$�$$�_�w$S�	��̀