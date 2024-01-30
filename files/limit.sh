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
BZh91AY&SY���% =������������ � `��x�g3:Ѻo4�/y�(��b��������m��(�M��42I��Q�&Bi�Q�F�� ��j�S�A�=#�� i� �i�Jjb)�M�A�OP h @4i�i�� I��)�d�OI���P�  ��H� z!�� �4    $@$�������2Di�=�Si2�z����4���Ƥ�K�U�/����!v0#�2I%�j2�fk}�o~�g�m���.~�\پ{j����7O<N�ʭ�ልT����oNb�'�w�����j�)1�;;l��Y��Ԙij]L<?�K���"��ɚr�D�24�&��$t� �2/,$���܈�b�"Kb���X�Q��Q��[D������=mq�?�NJ�&�5*s$���)X�W3Z���(,��?�W�N�y��*�$%h5��I`%I%PI��d@R��F$l��`�V-�Ih����Y)a$���T`'ɩ���;�"AH��6w�(4�eM̗JaD�K��$�χ�U���R�m��D�g�x����w���t��S,����z)B��7/~<10UN#��N&\u��
:+�%I	,I/��I���T�5���ֆ���ۚ\��I�	�8a��Dhص˚is���u2��@�P��.d��U��vO�
@��6/xy� ��+��@��۫�z���'��̌$����D��3(c��K`�̌�D6k�[�Ffd��z����!N��M*E� �r���&k��Wd��7�B]����CfV�y���.qP�L�Vӯ��u=�x����V�6~���r��y����*i~�o�HfQ|��l�y����0-�ӥξ |��t۷VbC�і���B,L
yx4��AO2dkYiʱ�bGn�v��U���>gwy&nTL�&c#�b��Z�7�i���&� W�-ܙF�sK�~"1j����c|i&�TAA�ApR6�N��
�U�� ��U�5�F� ��&����!#�˾�@�/��ڬM'9�[�q�9U>d�_D����6�`sDDF�gAo�L{L��?9�Yr"bx���kT,W��dTҺ�CRdRQfYG������[:x5�[)ڻQ݄SwS�F,�|�5\�:�����TZ�E�����p���n90�U\����q[��5���繮v/8��p�L9��F�^g��5SGf=����m�1]���|�jh Y�����Ο�x�vu����_r�����nO?,A1��������b
�/��2�KW��Y����ݹ�!�G�)W)L�x�#䋿���n�3���F;A- �`��E���B�a|��"\��� ��D��"X8wbS| �? V�E%���v�}�!XY��+�?&����BU�)���Z�R[�����@���6ྞ���;
m�fb��Y-����R�J��!�i	 �V@ pȸ��&h�؛%o؇wyϲ �0�`x@���T���mt_%�1n�l:�R���%�@4x��E� � ���'�uH�PBߋ�u&�C��c ku�[y T�GRTp����8�#Tܞ�@�� :-f	�Ρ�7WL,�s%G�nBDNcQ���X�AF��]>���$�D�!��-<xБ�ghjF�����^�Oe ��&��v�΃!�d�*�8��UUUm��ʢ�3�8.f я6�������0J83�wu!��ijcO��m��6$J�*����l#��ᵏa&�fq�֟�Y�;6�r��K�ԇH��f�Ϋ	F;4Gm)(AA6��|�J���1fIp��m� V�&�/+�()���E�&m cBF�����I#�y��l���[|��,� 3��h����;	3�v�Eٯj���$<Ϙ񶲁Ȩ���i���)3�f�t���!
ӟ6� 1C�H�	�x���N�\@@O�a+J�b�Bݒ+1ސ��i����Ǚ��vJcD��J�ʤG��$X7���yx��-������pK!L���0�c�����d�93 �ʈ6$y���	R�E]`Vj�a'1{ى}c)�ؙ<J�6�@RZ��,��`q�py���z��hI2�D��b����f s$P�p��gq4���K
Jʉ$"B@�@��WH�5���"=l]g[�їL�z���R*�Ŝ��F��kb(W���@�g/Zj�i�AO����SDrb�`�2�#C8t�����KL��(��ε���t\�;���F��d�����󜂤�P�Jˣ��%�(3V�����$�ƈfê�aģ�rE�}ư/����0��v�ȑ�e-�����.��uq{�*��ȃ-�"�������p��g�`��n�%n�))bM4�+Y
(d�B�(i0l"�R¯M�(�4kM�錁Ƈ�'V�6�M���^�9_)��2��K	�R-@�����|�� *�,R�IR�C�tg�&�����ļ�Զ�c��7R#$��CrBJN�e���5Q"҉�;
В̄���6���W���$��@߿�Z:�d!j�e҈�/W�0A���xa���B�h�8DдL�H&_ꄐ�"�,�f�f�l��i6��t�:���A��%�����xF���	�4���1&U�C|��86�=d�m�+�����|`ʕ!��y�︆*Tئ�F&��9��fJ�$�3i��s`ǞyϚ�����hp7�I�r�:�䡳�}��	����?�3+�!�$�J��0JD%��C��uO�w�l!���1�1EX�X$������h�����z_�����"�(Hk�p��