
function CVect = createCodeVector (s, Size, GF_Field)
%*(2* GF_Field-1) Sune se funksie- creates random elements in GF(8)
CVect = round(rand(s, 1, Size)*(2^GF_Field-1));


end