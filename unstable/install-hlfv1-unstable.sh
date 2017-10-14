ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ]p�Y �=�r�Hv��d3A�IJ��&��;cil� 	�����*Z"%�$K�W��$DM�B�Rq+��U���F�!���@^�� ��E�$zf�� ��ӧo�֍Ӈ*V���)����uث��1T��?yD"�����B�y"�Ĩ�D���A���� <P���lh��6aG���-{�+�2-;�E��Y��h
�v8 �'��~3l��<7`����Z�IY��F���:2��c,�P�ش-�$ >�b[�v����F� )q�;:,����|:��?z �~��+�T-~��,>o!�Іe6�� ���c9dly2�?BȔՖf�* �ĺNVB��lZ1X��R�E�H%��4��ݦ1р��tw.ꇙO��i�7��dҎL\�t�x�o�zVMMY4|Y���mwA����4�:�_XD�&U��:�"�&�C�dc�����l��,�JVQ����]���C�9$�"����5�?�CZ��Ӯ�Ͷ�x�����:�#؉
aa��S��g��P\���&jP��V�jg��ΡYs��E��b�e8����&�W���㗖�Ȁ?gԟ?usd�l�Z_}t�eW�c�L�3G��݇4Q�0�m)�>�w�P�Dl�����(�9�]l6�]QQ:�g=Х�L�[2i��=\�s[�������Ɵ�i��۠N^4���Q���� ��(�a�	?xOf����X7
w׾���}�`����b0H�?��AQ"�bT
F���*��w��f��jpvL��&PT�O�L�1���\�;/V���;�C�[<��{���S�\ǐ8�Y�`]�k��Oe�.�g�1���U�Z��l�!�m�4a�/,l<H��O�{�'���G��E@7���Mf`ȱ1^���[:}4��62A��Y�ƀά�ـ6�^��tܦ�b���l�vL�3��m�Zڴk�� Vd"�\����Ox��mx�,��%ON�nb3�(m�u�O�sަ��������S«��O�dX�m�HM���Y=L";Ru�������c��4��Ԏ����	�hG>x��F�+;��Н}k4UG�U4���a�|��������\�D�G�%���p)PJ
�c��y+�կ4��藆Gp�#��ޓ�ԓAR����\m2>,��ɺ�do���.������
� ���*`����做c��|`7����h��D-�A��1ͨ�^
Yܰ�e���w�qG���M��h[��q��j��&�D�A~�x|xMID ���Oڣ�!i�f;< �°�\�k���Q�ji<8�8o=8��"���4k� #|5�n��bz8�x|��[2@t!1�1���Ѩ�����n�E�h��:�H{L�����vf��6� "3˪S��-ޣ*؟� l�=6!c��g�Ob�?�ݥO;V�F�rG�Y%�w��=�A&���J�]�HG�B�B:Rl�mhJ`�ـϹ��MƜ�{�&�ެ#��朧��[�G�g ͠��x��8�&�pߨ�&�3��Q�t[L�^P5l�~=B�jy��N��X���l�YP�Tl���Ra�����`g?�~�	G���_���l�!���|�6�ȿ(���/��W����øޙ{���h���O�z�3��s��͘��:i�iR
Dk��=.�-�~�:��{��y)Q��w&�	y��gϳ+z;�ϯǐ�/h����"^nZ�����T��=̿���f��@ ��B�+�[N�6���K�&+�zQE�-4�&�H�/�O>"��;���-��b���ͥ+����@��w16-DK��na���v�@�B����;����9��#��{��lx��้��`�%a��ܮ�<q�!0�V�<����k��֥s�d��:��M+a2�~}>�8�,�O�A�'���r��������;9/��>����_P����������a����Cn ��H���h(���U���?��S��gF�4�,����m��v	v�vг�k�so�!�S����X&�^��x��@���+����v8��;�?}#�^���m��>A����hhj�C����������.dnZ6@���W�mj���m���Z~���}�C�=��.vB?9&��bbo�g��}_��ŧD�O>&"dK�f����.�	}b�,� 2"�gyN��"#��s��{U:�|��z9�}�L:s+d�E�߱w�:V�N��l�=3[�g�����o�W�m�=at���G7f?�5Ģ��"0�Z� ���z�L���ޙ���k0}������v�~p[����e�?*M���B��[��Ǉ��P"��\��?r��]]
Y�茨����k~nDk�ǁzO�=�0���_\���;a+��ܥ�w}�Nm`Gi�Չ*��������e��"S�������qY,cK�7lPvB�B?�'�����Q���J�����Z���)Z����+�������n�lwf�O���l���O��s@F���2�p�&�.��Q��@H�s+ю0Ip�� �����i}�P!����4��6z�.zqSwiƳ��LQr�^���l?����&�AxIC���):&�H�+0��gi&/�ČS��ffΘh}:YƬ��raLu*�����\��0����)�r����C��s}���%3��Ҁ�@Z�"��HuxV2��{5c(�
���í��@�}Bw?��Ai}��
�����������6�/��+����?ᰴ��\	p��5w�}���o��������_��0e~�	���"I��vMQ��Z�&)۱X�V��`"IDRD�Uc!I�R,����v8X��7��k�/_sӄ7���Nn�u��/���6�������'�>�6,lښ�����6lT��}��&���W�|5�����Y�;k�_6����mp���H��~"8sb�ͫim�a�)A��a�8N�h�1�`����v}��+����y�wj���?$���j���n�6m,�����/E�u�ו����O J��Jʆ;�ARz��kd��A7�O��Lm:Y��\�V��lY��{E%��F�5A�n����v����Ĥ`��l�PPB��@q;
cU1
aJR8J�ІԮy�Z�V��G!��d� �*���lB.�X�{#��&2���$�r7��٢�w���˞�gz�mTé�^�&��}|���R��\�����J*��%��s��+���	�r��oT3z�z����e�B��ϔr�<�����J;�A��4�}�)�o]\Neb����s��Ѩ��[g��E5(\�%e���ʩ`���8h����5�|��t��`�����	-�`e �qr��
V7Q8M
�T��q�*UΑ���K�s��`ڂ'g�n��S'�x��e.�ި�N6u�;=	_�����U���C�vO
'E��e2F��Q&m+�K����T��32��\&���)夘\Oe	�s7�'Y9�q��/�1Ӽ,�s���Ϳ�N�O.�v$I��X~�3�'�Q�X���}y?Ւ��sѳ�Y���Η�Y+�#gR���w�/���AN��Z�ު�n*���Փr���^1�k�)�B�s	��J�v�\b_��[�t��l<��0���~�c�E$ M!�������r''����
&d�.�R�D�����B佑H�?V˧HچW��I,�0�^F��0*'��q��P�l�ޏ�V�MO�i�j�T���E��{��qn�
Z/!Ţ5_)ʻ���|r���~��~:�F�@3���c��?��S���9�Q��'����3�obl/�[��W
�h�﫻}4����V��K�����?!Q���Vc~�Q1{L��O��ҧ\.��#6Y^d����U(�!�=8��c-Ӛ��S��P>J�[�Ϝ�zGO'�rU�/A�A\��,�N�*T��v�ҼJ�D��ձ�J��e՟r�q��+ýpZG���^0������S>� T�@����{e�P<����Snh�n�s��/~�_�i��k��
�l�ߩ~��/��g��u�ϕ�������q�nvS��=��#!�G!I��$u9�]3�NV`9�&wyRw������z����Y:�L!�)��u���Xc������m�-C>��ֽb{m�^�¤\��7��=�ܳ�ہO��^��4�����=x�_	["�����ai��q5�$p�g���l<G��m?�ui�������(ˣ�[߁������4d�Q�[�G}��F �u�>�D5��X��Ѩ.hhW�@�-h�:�~�E-����Cvi�?��e�8��5��} �~g� I܂����X�C�M)�6R�*����EPE:�$�jtd#0�`��zú2�1�=l��/y����<ﭹ�F�=
z�X�[�y��N�>6�>��A�li��`����d���{u]�xͦ?v5�B42����vL��k�������-Х��`��H(#2}�F�\it)xtذ�@h h��G���_��!��N0*�Ѷ-�v���]���UOޞMI �E�����b�L��6(��
Xа�|�t��ctdΰ����!SP�b}�ʭf{ã	m�3���cj*��gHph�D��/����+wu�I�;3���k�`����|s9����r�V��>���2���[�3t�C����JD��6_Ym�h������c�vz�k�2��.��<)���e|�	n0J����q��ְ)���t!�gY�`����R�sʯO�$���q�pwt/zR��T4Z�D�*a�f �:�h5�\�{A�xp(��R�c�$�&r��M��ZU<	��O��)v�������G{�,!�d��^�W�i�"���P�%�,��[9o�C�w��V�j�MG�]�TT6k���<&�=ԍ�ڡ���Ф�-�v����E����8�#P�vã�t7�5m��&�S���^����l��	�2$s��v�ڐ뼂u]�?�a=�'tp�m����J7���D�h�#�̧�'�t��}�1���G���r�?}o�Jm+��B�Y��Xc��L��)��G���-�Dz�o�B[~�#&��޵�:�������"5��`�P�t��T���I.SR۱�87��y��rb'q�<n��I�X �h	����쐘[�fB��`�;`>Ǐ8����-�9��u�}��������m\����!ls�O�����<~%��~�g�?��.�ŷ'E���?W������o���~G>Ǒ���������譣C�����5t1�ʟ~�Bѐ�H��*�X�
G�r�)IaM<#íA*dT�	�lK�!��_H�x���~��|���~��W~������䏞��8�{�],�;X��G�^�h��_����� ���z/��� ����?"_J���=|�0�O��v�m��{��n��b�S.Z�����n4Z>6�t,��z�l2,}�t:��~/�/X��,�
�-��W!>tUC`Zv�P؍��Z3�XsA��ٝ�V&6�.iB���B�@
��d=[��
�3DH	���N���HkQ(
&g���1[��ǍAl�h]�X74|��L\�����ns����L(�̈́	3�rs�k�T��*n6��i��B�4���E�y�W/��3^����3l��׏��iz���y͠:� S<���S|id�|�k��t"�.T���~�.�쬄��3%Y,SVF�+e�B3Y��"��)�����$����5?]O"L�A��	3�v�I�ْC�Y!��B')�yD�:)��"}.��F�4��05+��"S����yx���*�4߉/&=T+��.q�@汨F.��L��w��.����43���dMk�IJ�UKe�H'�Qz6nRbnn�'��X9�����������^�Mw�^"w�^"wE^"w^"w�]"w�]"wE]"w]"w�\"w�\"wE\"� ��0�.�f)E���O�J�Õ�Rb��9��7��x1���8��60�.��q/jgE�s�*'�K螻�<R�[��۩����@���������A\�S붗yj:Ċ�Hz�3D渁gC�iT�r���f	~����ܔ	�jiZ=G0��S�DY
7��&��	N���Hj��j�����&�'����8c+s�ٲ�#t-��Itoi⭈�Sf�[87/T?:5�r82�1J�a�C�9�)�fbX�vb��(N��<]�D��eS}BᒹӊJ��ܤ�Gd��J�~�̢Ԁ��˼[�w��ہ_8z=�A�(���G�=z��r�?� ���u���n�}���o���&���G��Z>	�s������G�N>��^�:5]���/z�����x#�ׁ�����[�(������+�o<��c>��������<��+EYfi�2YZ�|ވ�r��2y���r�b��ۭ-�/�/Z�'X����8���-3a�3I��Pr!���Ky������\�-�
&�qD�ilJ����]	���o� �D����tZ�������x�BH5J����Ȕ�S�cv�W������T��ln���z�X`��z�mQt|�TZ�8i�F�֣��6H�;*?NWFx�Dj"���L�x����+�4k9M�S���4K��� #�@��P!iAf;��3R�[T�F;*]n'���HĐ��sK�l=Qu�4_�/�SdMQv�)�e8Z�՚���k�&.v˃A�D�	�k9˂�`d-�~�l!���9m�����]f�tÚrܘ3U���-^�J�d�G����ǿu%�ā����B=��|yP�����δ[\n�����e��]���4�K���� �u�#�q��"��"��Y���j#�o?c�gf��e\vGn��.�#����u�{����7�ڴ���
G�[�e:��Ɇ�Vyc֑�|&Oԓ�8�Vla8,)�zܯ���X�.}6�0Ōb4��í��y���è���F��J��lV��*\�ڴe�6��M��6���x��Gt�:��Sȇ�N"5�u���8R힟Z{:��A�|�W:�dZ�R�%��b��҂4=mբy%٨(�T�/��1�.Efi�	�ys �7.5/E�a:��&S�v?�Ry.B�[Åip�X�1#�x�E��³��y%OdE�H+E"dg��xXS#S�1�+��-��l��U$#3I;�d�p�G����4�2An{�*de_�L$k;�*�"0�]�����W+�Rz*�+����X��R�C��Vp�	���c.���*�5
%�Cp�cq�K+ճ(�<Ki���M��et:S��;�
q5��)g��y�)�����E}h:��*��=����	җ�BJܐ��Ba�nF-E�N���|��r�J7D�V����l��5�T�Q���a2j��4�cSi�4���%��P6�-�F�U��r���.c&�.���_|˲���w��M7��ٍ�/Z���.�����<tlѢ���*8r3>�e�g�i�2ԧ��+����7��6�<F~���V��.��{����ϟ?�?|�<�����#ڎ���D� V�>E�΀oISeۇ�]�@\ӛĕ^)�y�y��t���:#��� ���#2�q>A~����)P��8�8uG�k��{�y䁳8�,O]W� x�|�`���ҡG��"�2+G�k��t�t�� Od̯����������H/���G/8���A����ד ���
�;��ts�����T�
�/�Vf��z�;�0V%���4���Ŏܸ��;
���4���3"�_���926ifw��]���H���I�S�k�*��9?�t�l�㧫���3�z�폭�U^Ѣת����U�ɎN��h���s�cj|oo==VG_Q�lH��z?<�HPP� !=����%-�8F�G10E�6��'
,Բ� z& 1�"v*�2H}c�]\ �3�w�ؤaв�S�� �fq.���Ի��&������ �˩O��/O��jNW@���+��V��&>$�MO��`������z�_ g�ADVТ3��1���X뭭u�v �w�W���h~�ʬ��A�|��,] R�̢�'���g�*�L�*�?Yu�b[�h���%���q��{��юW�]�Ip��:�z�"�gm�}��e�tb���2z��$��6�O�aKK�I�8�j8���jQ;�+��@��z!�g䊉+�������ԃ��?�0Ӱ�M���	�����* �.6��u��~�_�/�LF�}=w�_�1t[=:�� ��`S!z,-{�Q�k28� ނ��>�)OB�P��Zm6����6o(�� )�O◧q���粫k@W�g/"��B�m��p~в���dM`e�%�s%k�hٺ2�^���-%O�{��Q�� 8\�a�n]\*��/ ���P�$U�/cX%m �cp.�bz��v_�a�Nv �ݶ��^q�Eo���#�c��� �	����ӔT�=rQ�@�J�&(�񟅜	}�vp��,�]� _�.� Q�6����*�u�ii�~��@����`WV�ce2����C�&͝�\2�o�nZ�<�t;h�Y�$�s�>�n�	r�#��[�E ���D�4kX򪋫�=]�8�	�e��X4(0����.�lto�x����c��� �ކ�8m1���j�i"�-B���W�Z%kݶ�����jBH��:3r
����23��z�:��:�k�'ش_@���1���^�U�͉�	�C��	�z?붉�ֆ�Ɖ�S�9�a1b%)��������_��$�-4egCi�@'(�w���w\qpl��b��Iߑ���j�����
$��܏:�����������������m�����+���b3�'�`��}$��!>!>A@j˶Jv�ܰe%�vr��h �oó�g���"?��g 2�3T1Z�����Q��+\����*vt��R��Y��\��ծu��'���ӱrEC�\�f�H!K�I5	Ij���HdH	�m�j�ZJ�#m\��f��?F��v���p8�H%��}[�����DX�ì�gN,�*�����l�Ƕx�O�'O�Pa̐k�bǂxf��W7��IM����&�bY�qB	�0)&IE�cJ�RQ%$5eBB
Y3�)ሂK��X|Ҵ�����c3�D���̲��o���7�;�$�亣q��	Ovfߓ�E�V�]����wd��cw���msE�+ZT��\�Μer�W�2�d�9�\��/�\�f�"W*=àu�]��[�K'�r�3x�E�����_pa�A��P���3���U�A���.��{��U@@�[;�3�Π���vF�\�'-���i���Z�3��b��-��o�A�6io��;]k�nxl熉Bw�!���V7g�j}��nz��0�b�ߊ�y!��sEy��&��W� t�>���l<Ǯr�<�rL9���"�qY6����P���(
�Y�3i�N�CǶz������Yy��?��m�&<Z�����ZES���e|�,ˉ�\�T�F��e�3����F�X�>���d=�k��bj�g@�=fY-�&��%�9�'K�4C��gq�e.�ϕ�)�q����N�1��E�/�A=�-�O�8��L>kK��\����"�xc0��EL���:Mݝﯡ���,���vs��:߲]��d�X��`��2V��~��0���{�F.u���N���ͮ��;V�ߊw�#�9+3V���@!t����3��m����zq`�&�f�_�$9��G���o��6n��!�|'뿏���KF�f�CD?��>�+���ķ�c���H/��MoI�	zH{H�X�[�*t��{I���'plS����A��#�K�ß��i�ʦ}��K������_ �����hhh^���f��W��#w��:�{I���9&Y����E�v$*����l�Ȗ"K�X$��*�EۡV�����pTib���	�u��,��j�Wa���m���k/�g�m�ɼq�O�}\S��:iet�:G�+b�M	�;�4��u%?��8ɍ��$P=��E��"m.U���rH!2��@��E��-�=�ޖ�����y�?����ޤS)N�Z*^	a1eV��a�;F5��؟�����O���?���_z���Ɔ��8iw����������H���'�������Gڗ�� x���ʧ��?�����[�d$r���H�,�R����+��� ��]��������
�x ��D�O����.�Ij[�S����j��G�Jti_��2�g�����k�Rۺ�����-�����"�"���3 �����?��Iw���J
v'k>UL�*�N�k�������_�N8����W�p���ē�O����Ї�6@��{�?$��y�� ���?�� ��x��$!���U�[��?�|��T�A��n��
��ɗn!=���������?���'�#����0�c�{�����o��(گ'�*�z~���}�[Y$�N%�_��V�݋���v�f���s(��4�u�<��U�u��b�ߵ��Nc`���2O6�+NQ{��od��{���O�{�>��a��r5���;���.S,R�=Y�$�����|������/�es�.��Wc〝~͔����F��r>�i������'��eX�4���Ploy���?V{]�"GŬ���r����H�?�����˂(X � ���[�!�����h�?�DU$��'�O$��]	 �	� �	�����?�_@@��I��u���[�!����?�_������������Û��ε����ΙtN�� �YR׭u2`��������g��_��Oe}�GC���{��?t܌k�Ӏ<k�:χ�ڈw���7���>���GuY�˄b�鍂�i��\

��u���O�}����Y�4������Z�G�!/u��� �X�%�R��BKſ��{�[����-m!�tBvJ�)�wN��%���F��beL��dR��lkx��D�;g�-��IK҈�^1�F��6�L����m̩�_���	�G<��*���[E����#(�k �����C�����/�_���(��l\8g�Y��Čᙀ��� �#:�.�0�X�g�����B6d(�
��3�(������������˞�/ω�����by��})���(4�S�Y���.�����g��D�@]G�'��{��#!gml��y���<�N�6]l���{N��XM����%JgA֌��}8n�g͟u ��[����?�C���������?��	����ڀ ����?�e`�/�o����3뿣i��QW��8�b;z�9+f�z{5�.=o2v���{���(����x�L8߼�lW��nۧ���v��٣�U��2O����e]H������M�y8[���t�	<�o��ߚ���?�����k�o 
�_��U`���`������W��� ��8�A�Q$�*���ʫ���/����>�eя��	�;+�����C��lYK�)������0Ǯjk�#g `/�� ؟���3 �R5l���R|�T��! o� Z�yJ]]l6z����tK�𕷟c�F�)��B뵶K�V�m��FlG=N����1f���|.�ެ�R0��2���=뉾ǟ��-����ʷ3 ,�%�t��R��������7�'}�ӌ�Ad�O#I	x�<컑Tn�X�ysҧ�~nҮ�r���`YCjȭ���&Z��R�2&M^���P4TK�ԑ���c�j�c���t�w�$�����Rv�ۍ�,_�{b"-#��i߹�+���������E|�L�9�������h/�������A�U�����>Lx��*��[�?�q������(�?�?����%���!�YT��ߙ��2������!���!����'��kB%����e� p�ǹ�?#Ȉq_�}�ei!�p��#�f�� |�$g��\D���b������/��J�3��~p\�Z�2���sH�Ir4�b��܍�5:������=T�I���m���H�Z�Ï�jCl���~�l��������oƗ��.��<u���uI�7�����}�6-���V�p�'�'����S	>��ou?K�ߡ��������� ��>��0�W���I �E �����׫�5�r�o_���AU������_x3�����/��汿��ˬ)�/�KRu���ò��oE����*i.����=�����������wQ�������y�Z�7g��G^?K�^�m���gN��>^2VY`�ӕ:��j<��Cw>�uQo�3;I��8/+޴9-7f�!�����q��!�m���U^��o׶+�0�-m���$M����*��.��Q�����[���]�C���q*;Օ5K�s�b1Y�w�3�h�/f,4[��)�۱[���<k�Zl3:�n��e��R5�U�0�hc����xr�i�;�Lw("=�]P�W���քj���*�����
�O�քj��Q
����o����J ��0���0������, $����P���ׇ����KpP����_����
@�/��B�/������������?�Z��<G��=�?�%@��I��)��*P�?���B� ��������P3�C8D� ������'���+��5���v�g����� -��p��Q�o��� � ����#?$������GE@@��fH������H�?�0��_�X�(����h���� ��� ����W���p�������������!������*�?@��?@�C������� ��'1�����o�����7���p�{%@��a��r�P���}�������u	�C@B�O���
 ��V�%?���� ����P�����PP����� �86��!�S8?�h�
4IEW�`������>�s���>M3���z��@��)����&����ѵ���N���s�8��@�6^�7o��b׊^O�Ӥ)$��ż�8�mb���z}Z��(,���%���hʢ8ܟ��r�af�����\��y�6�(���ʽXC�´��:d;���x�����bSq����q�hI�"5�/��Ó��G(��!��>�|�?���[+P��C�W�����������Z��b��@�����?��������S�[=���<�;�������E·���[�S��D��}��f٤�����,Yk>Y��y�|-��Ĺ����(�a�\L�s[�v�2�Sd֌
�ҵ���.�1���V�q�8��ߊ���?�����k�o 
�_��U`���`������W��� ����g�?迏�[����������n:�䱼g���ʗ'^������g�Wmw�v��I^�Ȃ�s�}K�����*s�fC9��K۝i�x�����Ɖ��g���OD��Y|��c=���]�eyvs*7�Kҋٌ.�a����h������W����r�����嶤��-��������,�'}�ӌ�Ad�O#I	x�<컑Tnb��1sҧ�~nҮ�?.���Z���΁�cq!�`2	���i�ya�s�����Qh�{+OINf�z~��x�>4f�H�q֙0�踣V��6c����_wW��?�Ϣ�׷�����q���o%������������W�?�~��	�ߕ�?�/�n0�,������4Np��U �'q��K�W�j��5�2=�CU����������U�-��tdY�]���ice�I�B�z��O�"P~v�GK�{��L~�,M����\ԽW���{��.^,?��~�-?��gj���[��.}C�����f]ޜ�[j	��ؒ�#:R~rZ5��jHRq���[�rG�.g��]�0�z�Q����W�*��|L�'ϲ��Tˆ��Z��d�C�0ٵ릣E�Z���`|�ا_L��ڢ�_���͟�۹��e-�x�޾qp����ov�Y��!��'fJl%�,qno�쨆d��e�G�0�V�=5;�XF�9T��ʧ�����Q�T1��E/�y���.c�#��Fc�s��D8����$�݈�XJܦ/�y��MP{>X%�M�^_�ǂ�W�}�����@B�1������?.`��%(?��<A��0�B¿>L��0�i'��<�hJ���!�Q ~���6�?
(�����W����g��+l<;���`������Q0���c�=���3r�Iѧ��G��g���G���
��+>��3���a��*���#8�Q���W	*����0���o����������ʛ������;y"���T�ᄝ����w���¢�i�N-���f�a���V������n����Đܻ�׿�~w��6�Ϣ��ݱ��hu�#+�݆�����v@�O�L�f�k���H6��K�EȊ�&��<k��G�9?��M�'Z��l?콾���Þ�~~���D�q"��vC58��ӝ���2m��b,j�U)��s�OL&�e5���Y��͈��h�ѫI�Z��84�|�r�ӯ?����-eN4�6Z��᝶������P3�vsѸ������@A����`��Tp�g|6�È�y��<I�:~!{���h�O����׿	��`��s}��
̿D����?�������3��V��dm"2Z��9�,��h�7��0��J�U�:�r�I>�/[n�{�l��[�џ�[��;�?�����(迫�{�8�*P��߿���	�H���n�����P1���@@;T���������������o�����i��i��2������y|\�������v��}}�c�G�s�����(`�D=Q�2���\�SY]�uz}L{}L��X1Z��{�
{o��޹����sR�����ܜԩs���Cz��V*�����[9��� uj��mw҉Τ3�f3q}���D��w���Zk?.]��O�׬k+}��u�ו��^�y8���r�θ։����<t�v�Ѭ�uݾ�z 
������T[UL�=��,�mfe��mW�nɑ�+b���t�j5��^����������RS��y�g)J�X�{�94Y��vŮ�{{m�
�x�mؒ�4l��[edK�ڼ(��O��*���Ƥ�1���T���`8��j�߫�X��x�mg�j���G�+�$�ek%�������//��JR$=���WRO?s��?M�?������	Y����^�����<�?����,�A�G.����O��ߙ ��	��	��`��U���C ���۶���0�����
��\��������L��oP��A�7����[���տP_%�[d����ϐ��gC.������?3"����!'�������+�0��	��?D}� �?�?z�����X�)#P�?ԅ@�?�?r�g���B��gAN��B "+����	���?@���p����#���B�G&��� )=��߶���/^�����ȃ�CF:r��_�H��?d���P��?��?�Y�P=��߶�����d�D��."r��_�H���3�?@��� ����_�� �?��������m����J���ʄ|�?���"�?��#��!���o�\�$�?�@i���cy�	�?:���m�/�_�.�X�!#r��GS�I�%~�jF��yn�[e�dK�[�k�|ɤ�3,K/k��1�2�9�c?�ou����A��ܥ����������Q��������]�bS�[��d���$=���uQ&c-�vm�;mL��-��8��XPkq��4_�*�#6����vSZ�t�z�t�v����tX��vX
����5Za-ɜ��'�����5�7�ݎ]�F���-N\�vI��J�=(�Ȋ�:�����B��9#�?��D��?Zìo�C��:����������D�
�K��?t�H�O��&-�j�=&&"��|��3�-�^O���j˝=�?���h՞�ڃ�F7�Gnk�5lX��a�p����X���;�U/Ķa�&���1�W��R�ڜ^ɁM<H�v*�$��^K>��"��"e�oh�F�36�_�\�A�2 �� ��`��?D�?`"$��]����2�������g��ݲ��懶����ȑ�b��:��6�����S��5q&S������׃m���6�T����]�$�vw�z�k�h���I�/��a\�X��CҚc����̫N6����ms������v�R�8��X�q���uv�O���U���-�V�_��v�&v��c�B<�~������81����fU���J��ɇ������	NU��ө�l����Qk�2���r�0�Me*�q~�����)�ұ�q $��w�~�4d�����݁��!�Z�~Є^맷�^���b��*޺���=rJ������+�d�?� ��_���A�� 3�z���	���G��4ya��<��H�?MC� 7�?�?r�������O& �����n�[����3W�? �7��P2{����������@�G���o�\�ԕ�_��2��+@"��۶�r����2r����#r��s����d�7�?Ni���9�C�J�� tĎ8>��|o��-�"�Cd��aĵ�S�G�>�~�����]=�~����܏4�{E��)�s��y������~�E'�׻≪��'qj��w�ڲ���3�7���joHE��Ά�̜���i��F��qt�1BX�Ƨɦ�ڎ⫣4���y��i�ؕ�_M��6�(�#-� �
<i���p�Lk}o1���$4��y��31���D֩�b�ٌ(r`Nxf5iK��&Y�膛�06�FrԦ�^�dحX�]s����l�>������\������������d ��^,��-n��o��˅���?2���/a Sr��_��E��&@�/������Z����D ��>/��)n��o��˅��$�?"r��W����&�?��#�[���������n�^������ʥ�ڲ������?|�?�e�yx��76�����~/ {��S@ink��1`:nC���R���=U���v��h��Y�|�o��D{�DU��4�-��т��ڡ^���V�˲B>������$�?���I ��Ћ��'(���.,�U_�R���D��9W��[~҅E-,��֞,�]Iٰ�i���Z�L�a���t���C��9��[�ۊ���ӻ��\�ԕ�_��W& ��>-��%n��o��˃��+����Y��g�ohE޲8���%͜I��XR��bi���R�d)�"5��,�0u�3�%��s����ߟ�<����?!�?~���~���-�әϟ��L�TK���^?��zm�Z��iT.<��y,�	M4�v����v�?��^�ט�b�x��EMk��s�;���<;j���i>��xR��@���!��h���<��P�H��t(�p��������Ar�Z0qQ7�M���?���ǻ�x���Y�9�U����b����Z��N	_����}����td�����}��4v.�&��zh�Y̏��ꈝ�����1?��Ӯ����e�`\������M����eh��^K>����/�g����������E��!� �� ����C9�6 �`��l�?D|�����-}���ύ�}�"��G�-�^�t������i��� �y!��9 ���u�����-H�T+[��z���jQ3G���OelE���GG��O��bSl����:��C��CU�S�Y��m��$�N_�yXj牚׻Ov��x�J#��bwX�tL0���&�M��|�ZIItr��=l����FC]-UI'd��Q88V�UD2���{�������f5��k�a�4��J�Ӷ�g{��p�HS��WW��S�f˗��'w�.9�
ǵ=;����Ŋ��?<`���Uh�������jcD��Q����p����L�������G��s�����>��O2������L�;���s�t��h���=u������&Qԃ�^Ğ"}�j�ǎ0�x�W��~�!=ܝx��6q���i�M9���	�;o��H\{�
��t�����z����(-4�5�χ�39��?/j���ܱ��k��?o~�K>�7����D��-����>���}�A�|������"t�%t-\`������p��-'#�/�'����z�>1͝��XhF���O�S1#�H6'�����&&������\m����?��@��ha��.��xs'H���#VQz޽�n���G������"
���~{ؓ��K�߯���~����ϓW�Q�Ƿ����w��v�������y�"� ���w���ė��7��m�����yz������x���ڜ�f��'<��ǧ+��q-9�g��>��E"|��u��׉�����N�L�KA�����@iV������ �$w����0�Xx��_���+�M��ͭ�ٝ��%>I����s0�7̀���z��?��y�8��ï���'Y2诅9mnb����ȧ'�z��[���������*�Oj��;�j�c�ߑڭ�"?vr'�&0��T4�k~�I��^�0��t���/��L���{���&�(                           ����-�3 � 