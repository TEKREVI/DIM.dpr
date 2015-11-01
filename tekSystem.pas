{===============================================================================
 - Независимый модуль без инициализации и пр. пожерательства типа стандартного
System. Автор: TEK и немного божЬей пОмоЩи :)
===============================================================================}
unit tekSystem; // 11.3.2011 >
//=============================================================================>
//=============================== Раздел обьявлений ===========================>
//=============================================================================>
interface
//=============================================================================>
//================================= Константы =================================>
//=============================================================================>
const
    // Цифры >
  _0 = 0;
  _1 = 1;
  _2 = 2;
  _3 = 3;
  _4 = 4;
  _5 = 5;
  _6 = 6;
  _7 = 7;
  _8 = 8;
  _9 = 9;
  _10 = 10;
  _11 = 11;
  _12 = 12;
  _13 = 13;
  _14 = 14;
  _15 = 15;
  _16 = 16;
  _17 = 17;
  _18 = 18;
  _19 = 19;
  _20 = 20;
  _21 = 21;
  _22 = 22;
  _23 = 23;
  _24 = 24;
  _25 = 25;
  _28 = 28;
  _29 = 29;
  _30 = 30;
  _31 = 31;
  _32 = 32;
  _60 = 60;
  _63 = 63;
  _64 = 64;
  _127 = 127;
  _128 = 128;
  _256 = 256;
  _365 = 365;
  _366 = 366;
  _512 = 512;
  _1000 = 1000;
  _1024 = 1024;
  _2048 = 2048;
  _4096 = 4096;
  _8192 = 8192;
  _65535 = 65535;
    // Цифры прописью >
  mTwo = - _2;
  mOne = - _1;
  Zero = _0;
  One = _1;
  Two = _2;
  Three = _3;
  Four = _4;
  Five = _5;
  Six = _6;
  Seven = _7;
  Eight = _8;
  Nine = _9;
  Ten = _10;
  Eleven = _11;
  Twelve = _12;
    // >
  _X = Zero;
  _Y = One;
  _Z = Two;
  _W = Three;
    // Знаки >
  mgl_Zero = Zero;
  mglZero = Zero;
  Null = Zero;
  First = Zero;
    // Размеры >
  ByteLength = _256;
  ByteMax = ByteLength - One;
  WordMax = _65535;
  ShortNameLength = Ten;
  ShortNameMax = ShortNameLength - One;
  ShortPassLength = Eight;
  ShortPassMax = ShortPassLength - One;
  NodeTotalInc = _2048;
  NodeSelectInc = NodeTotalInc div Two;
  NodeLocalInc = NodeSelectInc div Two;
  NodeSimpleInc = NodeLocalInc div Two;
  FileResetSize = One;
  mnKB = _1024;
  mnMB = mnKB * mnKB;
  mnGB = mnMB * mnKB;
  mnColorDepth = _32;
  mnDepthDepth = _32;
  mnStencilDepth = _32;
  mnFPSDivision = _1000;
    // Время >
  mnMilliSecond = One;
  mnSecond = _1000*mnMilliSecond;
  mnMinute = _60*mnSecond;
  mnHour = _60*mnMinute;
  mnDay = _24*mnHour;
    // Номера дней недели по инглически >
  mnSonday = Zero;
  mnMonday = One;
  mnTuesDay = Two;
  mnWednesDay = Three;
  mnFourthDay = Four;
  mnFriDay = Five;
  mnSaturDary = Six;
    // Нормальный порядок дней недели >
  mrMonday = Zero;
  mrTuesDay = One;
  mrWednesDay = Two;
  mrFourthDay = Three;
  mrFriDay = Four;
  mrSaturDary = Five;
  mrSonday = Six;
    // Ёмкости типов данных >
  cByteSize = SizeOf(Byte);
  cCharSize = SizeOf(Char);
  cWideCharSize = SizeOf(WideChar);
  cWordSize = SizeOf(Word);
  cPointerSize = SizeOf(Pointer);
  cCardinalSize = SizeOf(Cardinal);
  cIntegerSize = SizeOf(Integer);
  cSingleSize = SizeOf(Single);
  cDoubleSize = SizeOf(Double);
  cInt64Size = SizeOf(Int64);
    // Длительность >
  PassTryDelay = _1000;
  mnMaxDriveCount = _32;
  mnMaxDrive = mnMaxDriveCount - One;
  mnTestFrameCount = _1024;
    // Тпы узлов >
  mnNode = One;
  mnFile = Two;
  mnFolder = Three;
  mnDrive = Four;
  mnDrives = Five;
  mnComputer = Six;
  mnWindows = Seven;
  mnRAMClass = Eight;
  mnCamera = Nine;
  mnKeyBoard = Ten;
  mnMouse = _11;
  mnDrawLine = _12;
  mnVisibleParams = _13;
  mnVisibleMaterial = _14;
  mnVisibleBodyType = _15;
  mnVisibleBody = _16;
  mnLightSource = _17;
  mnFog = _18;
  mnTexture = _19;
  mnStringList = _20;
  mnExNo = _21;
  mnFileImage = _22;
  mnFolderImage = _23;
  mnDiskImage = _24;
    // События от мышки >
  MM_LEFT_DOWN = mgl_Zero;
  MM_LEFT_UP = One;
  MM_LEFT_CLICK = Two;
  MM_LEFT_DOUBLE_CLICK = Three;
  MM_RIGHT_DOWN = Four;
  MM_RIGHT_UP = Five;
  MM_RIGHT_CLICK = Six;
  MM_RIGHT_DOUBLE_CLICK = Seven;
  MM_MIDDLE_DOWN = Eight;
  MM_MIDDLE_UP = Nine;
  MM_MIDDLE_CLICK = Ten;
  MM_MIDDLE_DOUBLE_CLICK = _11;
  MM_WHEELUP = _12;
  MM_WHEELDOWN = _13;
  MM_MOVE = _14;
  MM_MAX = _15;
    // Формы доступа для узлов >
  maNotSet = Zero;
  maNone = One;
  maCanView = Two;
  maCanViewAll = Three;
  maCanEdit = Four;
  maCanEditAll = Five;
  maCanAll = Six;
    // БукАвЪки >
  EmptyChar = Char(Zero);
  mnFirstDriveChar: Char = 'a';
  mnSlash: Char = '\';
  mnDot = '.';
  mnDirIn = mnDot;
  mnTwoDots = ':';
  mnBeckSlash: Char = '/';
  mDivOfCom: Char = ' ';
  mnStrColName = 'l';
  mEndLine = _13;
  cEndLine = Char(mEndLine);
  mnBreakLine = Ten;
  cnBreakLine = Char(mnBreakLine);
    // Языки >
  mnRus = Zero;
    // Строки >
  mnEngDefCharCodesLo = 'qwertyuiopasdfghjklzxcvbnm';
  mnEngDefCharCodesHi = 'QWERTYUIOPASDFGHJKLZXCVBNM';
  mnRusDefCharCodesLo = 'йцукенгшщзхъфывапролджэячсмитьбюё';
  mnRusDefCharCodesHi = 'ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ';
  EmptyString = '';
  mnRusExt = 'rus';
  mnDirNameUp = '..';
  mnDriveApp = ':\';
  mnSearchMask = '*.*';
  mnUsualMask = '\*.*';
  mnDefaultPass = 'First';
  mnLogFileName = 'Log.txt';
  mnMessageRus = 'Сообщение';
  mnNameStr = 'Name';
  mnLinkStr = 'Link';
  mnDescriptionStr = 'Description';
  mnDataStr = 'Data';
  mnArrowLine = ' -> ';
  MainExt = '.TEK'; // Разрешение для моих файлов >
  UnKnownError = 'Неизвестная ошибка';
  mnWindowClassName = 'mglWindowClass'; // Имя класса окна для OpenGL >
//=============================================================================>
//==================================== Типы ===================================>
//=============================================================================>
type
//----------------------------------- Классы ---------------------------------->
  TMyClass = TObject;
//---------------------------------- Массивы ---------------------------------->
  PBytePack = ^TBytePack;
  TBytePack = packed array [Zero..Zero] of Byte; // Немеренный массив байт >
  PCharBuffer = PBytePack;
  PWordPack = ^TWordPack;
  TWordPack = packed array [Zero..Zero] of Word; // Немеренный массив слов >
  PCharPack = ^TCharPack;
  TCharPack = packed array [Zero..Zero] of Char; // Группа букв >
  PWideCharPack = ^TWideCharPack;
  TWideCharPack = packed array [Zero..Zero] of WideChar; // Немеренный массив "толстых" букавъ >

  PMy1f = ^TMy1f;
  TMy1f = array [Zero..Zero] of Single;
  PMy2f = ^TMy2f;
  TMy2f = array [Zero..One] of Single;
  PMy3f = ^TMy3f;
  TMy3f = array [Zero..Two] of Single;
  PMy4f = ^TMy4f;
  TMy4f = array [Zero..Three] of Single;
  PMy5f = ^TMy5f;
  TMy5f = array [Zero..Four] of Single;
  PMy6f = ^TMy6f;
  TMy6f = array [Zero..Five] of Single;
  PMy2fArray = ^TMy2fArray;
  TMy2fArray = array [Zero..Zero] of TMy2f;
  PMy3fArray = ^TMy3fArray;
  TMy3fArray = array [Zero..Zero] of TMy2f;
  TMy4Char = array [Zero..Three] of Char;
  TMyString32 = array [Zero.._31] of Char;
  TMyString64 = array [Zero.._63] of Char;
  TMyString128 = array [Zero.._127] of Char;
  TMyString256 = array [Byte] of Char;
  PMyStrings = ^TMyStrings;
  TMyStrings = array of String;
  TMyLongString = array [Byte] of Char;
  PMyBytes = ^TMyBytes;
  TMyBytes = array [Byte] of Byte;
  PMyBuff = ^TMyBuff;
  TMyBuff = array [Zero..zero] of Byte; // Сам буффер, представленный в виде сплошного массива байтов >
  PMyBuffPack = ^TMyBuffPack;
  TMyBuffPack = packed record // Структура для работы с абстрактными буфферами данных >
    mSize: Cardinal;
    pData: PMyBuff;
  end;
    // Математика :) >
  PMyVector3f = ^TMyVector3f;
  TMyVector3f = array [_X.._Z] of Single; // Трёхкомпонентный вектор >
  PMyVector4f = ^TMyVector3f;
  TMyVector4f = array [_X.._W] of Single; // Четырёхкомпонентный вектор >
  PMyMatrix3x3f = ^TMyMatrix3x3f;
  TMyMatrix3x3f = array [_X.._Z,_X.._Z] of Single; // Матрица 3 на 3 >
  PMyMatrix4x4f = ^TMyMatrix4x4f;
  TMyMatrix4x4f = array [_X.._W,_X.._W] of Single; // Матрица 4 на 4 >
    // Процедуры >
  PMyProcedure = ^TMyProcedure;
  TMyProcedure = procedure;
  PMyProcedureStd = ^TMyProcedureStd;
  TMyProcedureStd = procedure; stdcall;
  PMyBooleanFunction = ^TMyBooleanFunction;
  TMyBooleanFunction = function: Boolean;
  PMyBooleanFuncStd = ^TMyBooleanFuncStd;
  TMyBooleanFuncStd = function: Boolean; stdcall;
  PMyTHreadedFunction = ^TMyTHreadedFunction;
  TMyTHreadedFunction = function(pData: Pointer): Integer; stdcall;
  PMyFarOnProcessFunc = ^TMyFarOnProcessFunc;
  TMyFarOnProcessFunc = function(CrntState: Pointer): Boolean; stdcall;
    // Файлы >
  PMySysFile = ^TMySysFile;
  TMySysFile = file;
  TMySysStringFile = file of TMyLongString;
//=============================================================================>
//=========================== Функциональность модуля =========================>
//=============================================================================>
  procedure DoNothing;
  procedure DoNothingSTD; stdcall;
  procedure FillWithZero(pData: Pointer; Size: Cardinal);
  procedure FillWithOne(pData: PMy4f); overload;
  procedure FillWithOne(pData: PMy3f); overload;
  function IntToStr(Value: Integer): String;
  function StrToInt(const S: string): Integer;
  function UpperCase(Value: String): String;
  function ExtractFilePath(Value: String): String;
  function ExtractFileExt(Value: String): String;
  function ExtractFileName(Value: String): String;
  function ExtractFileNameOnly(Value: String): String;
  function SlashSep(Part1,Part2: String): String;
  function GetExeName: String;
  function ExGetMem(Size: Cardinal): Pointer; stdcall;
  function StrToCardinal(Value: String): Cardinal;
  function ChrToByte(Value: Char): Byte;
  function PowerOfTen(Value: Cardinal): Cardinal;
  function PCharLength(pData: PChar): Cardinal;
  function SetInAppPath(Value: String): String;
  function CreateBuffPack(Size: Cardinal): PMyBuffPack;
  function DestroyBuffPack(var pData: PMyBuffPack): Boolean;
  function ClearList(pData: PMyStrings = nil): Boolean;
  function SortStringsInList(pData: PMyStrings  = nil): Boolean;
  function ExchangeStringsInList(Index1,Index2: Cardinal; pData: PMyStrings  = nil): Boolean;
  function AddStringToList(Value: String = EmptyString; pData: PMyStrings  = nil): Boolean;
  function RemoveStringFromList(Index: Cardinal = Zero; pData: PMyStrings = nil; pro: Boolean = true): Boolean;
  function StringIndexInList(Value: String = EmptyString; pData: PMyStrings = nil; UC: Boolean = true): Integer;
  function CheckSum(pData: Pointer; Size: Cardinal): Word;
  procedure FreeAndClear(var Value: Pointer);
  procedure RandomizeLine(pData: PMyBytes);
//=============================================================================>
//============================== 3D МАТЕМАТИКА ================================>
//=============================================================================>
  function SegmentLength(var v1,v2: TMyVector3f): Single; overload;
  function VectorLength(var v1: TMyVector3f): Single; overload;
  function VectorSum(var v1,v2: TMyVector3f): TMyVector3f; overload;
  function VectorMultiplication(var Vector: TMyVector3f; Value: Single): TMyVector3f; overload;
  function DotProduct(var v1,v2: TMyVector3f): Single; overload;
  function CrossProduct(var v1,v2: TMyVector3f): TMyVector3f; overload;
//=============================================================================>
//============================= Раздел реализации =============================>
//=============================================================================>
implementation
  // Уничтожение и пометка нулём >
procedure FreeAndClear(var Value: Pointer);
begin
if Value = nil then
Exit else begin
TObject(Value).Destroy;
Value:=nil; end;
end;
  // Переставляет байты в случайном порядке (мешает) >
procedure RandomizeLine(pData: PMyBytes);
var a1,a2:Cardinal; v1:array of byte; b1:Byte;
begin
if pData = nil then begin
GetMem(pData,_256);
for a1:=Zero to ByteMax do
pData^[a1]:=a1; end;
SetLength(v1,_256);
for a1:=ByteMax downto Zero do begin
a2:=Random(a1+One);
v1[a1]:=pData^[a2];
if a2 <> a1 then begin
b1:=pData^[a2];
pData^[a2]:=pData^[a1];
pData^[a1]:=b1; end; end;
for a1:=Zero to ByteMax do
pData^[a1]:=v1[a1];
end;
  // Контрольная сумма >
function CheckSum(pData: Pointer; Size: Cardinal): Word;
var a1,a2:Cardinal;
begin
a2:=Zero;
if Size > Zero then
if Assigned(pData) then
for a1:=Zero to Size-One do
a2:=a2+PBytePack(pData)^[a1];
Result:=Word(a2);
end;
  // Выше-ли первая строка в спике строк? >
function IsFirstUp(var Value1,Value2: String): Boolean;
var a1,a2,a3:cardinal;
begin
a2:=Length(Value1);
a3:=Length(Value2);
if (a2 = Zero) and (a3 <> Zero) then
Result:=true else
if (a3 = Zero) and (a2 <> Zero) then
Result:=false else
if a2 = a3 then begin
Result:=false;
for a1:=One to a2 do
if Byte(Value1[a1]) < Byte(Value2[a1]) then begin
Result:=true;
Break; end else
if Byte(Value1[a1]) > Byte(Value2[a1]) then begin
Result:=false;
Break; end; end else
if a2 > a3 then begin
Result:=false;
for a1:=One to a2 do
if Byte(Value1[a1]) < Byte(Value2[a1]) then begin
Result:=true;
Break; end else
if Byte(Value1[a1]) > Byte(Value2[a1]) then begin
Result:=false;
Break; end; end else begin
Result:=true;
for a1:=One to a3 do
if Byte(Value1[a1]) < Byte(Value2[a1]) then begin
Result:=true;
Break; end else
if Byte(Value1[a1]) > Byte(Value2[a1]) then begin
Result:=false;
Break; end; end;
end;
  // Сортировать список >
function SortStringsInList(pData: PMyStrings  = nil): Boolean;
var a1,a2,a3:Cardinal; s1:String;
begin
if Assigned(pData) then
a2:=Length(pData^) else
a2:=Zero;
if a2 = Zero then
Result:=false else
if a2 = One then
Result:=true else try
for a1:=One to a2-One do
for a3:=a1 to a2-a1 do
if IsFirstUp(pData^[a1],pData^[a1+One]) then begin
s1:=pData^[a1];
pData^[a1]:=pData^[a1+One];
pData^[a1+One]:=s1; end;
Result:=true; except
Result:=false; end;
end;
  // Поменять местами два елемента списка из под таких-то номеров >
function ExchangeStringsInList(Index1,Index2: Cardinal; pData: PMyStrings  = nil): Boolean;
var a2:Cardinal; s1:String;
begin
if Assigned(pData) then
a2:=Length(pData^) else
a2:=Zero;
if a2 = Zero then
Result:=false else
if Index1 >= a2 then
Result:=false else
if Index1 >= a2 then
Result:=false else
if Index1 = Index2 then
Result:=true else begin
s1:=pData^[Index1];
pData^[Index1]:=pData^[Index2];
pData^[Index2]:=s1;
Result:=true; end;
end;
  // Очистить список >
function ClearList(pData: PMyStrings = nil): Boolean;
begin
if Assigned(pData) then begin
SetLength(pData^,Zero);
Result:=true; end else
Result:=false;
end;
  // Найти номер строки в списке >
function StringIndexInList(Value: String = EmptyString; pData: PMyStrings = nil; UC: Boolean = true): Integer;
var a1,a2:Cardinal; s1:String;
begin
Result:= - One;
if Assigned(pData) then
a2:=Length(pData^) else
a2:=Zero;
if a2 > Zero then
if UC then begin
s1:=UpperCase(Value);
for a1:=Zero to a2-One do
if s1 = UpperCase(pData^[a1]) then begin
Result:=a1;
Break; end; end else
for a1:=Zero to a2-One do
if Value = pData^[a1] then begin
Result:=a1;
Break; end;
end;
  // Удаление строкиизсписка по её порядковому номеру >
function RemoveStringFromList(Index: Cardinal = Zero; pData: PMyStrings = nil; pro: Boolean = true): Boolean;
var a1,a2:Cardinal;
begin
if Assigned(pData) then
a2:=Length(pData^) else
a2:=Zero;
if a2 = Zero then
Result:=false else
if Index >= a2 then
Result:=false else
if pro then begin
if Index < (a2-One) then
for a1:=Index to a2-Two do
pData^[a1]:=pData^[a1+One];
SetLength(pData^,a2-One);
Result:=true; end else begin
pData^[Index]:=pData^[a2-One];
SetLength(pData^,a2-One);
Result:=true; end;
end;
  // Добавить строку в список (в самый конец) >
function AddStringToList(Value: String = EmptyString; pData: PMyStrings  = nil): Boolean;
var a1:Cardinal;
begin
if Assigned(pData) then begin
a1:=Length(pData^);
SetLength(pData^,a1+One);
pData^[a1]:=Value;
Result:=true; end else
Result:=false;
end;
  // Создаём "специальный" буффер >
function CreateBuffPack(Size: Cardinal): PMyBuffPack;
begin
if Size = Zero then
Result:=nil else begin
New(Result);
Result^.mSize:=Size;
GetMem(Result^.pData,Size); end;
end;
  // Уничтожаем "специальный" буффер >
function DestroyBuffPack(var pData: PMyBuffPack): Boolean;
begin
if pData = nil then
Result:=true else begin
FreeMem(pData^.pData,pData^.mSize);
Dispose(pData);
Result:=true; end;
end;
  // Дополяет это имя путём к пусковику данной программы >
function SetInAppPath(Value: String): String;
begin
Result:=SlashSep(ExtractFilePath(GetExeName),Value);
end;
  // Возвращает длинну нуль-терминальной строки >
function PCharLength(pData: PChar): Cardinal;
var p1:PCharBuffer; a1:Cardinal;
begin
if Assigned(pData) then begin
p1:=Pointer(pData);
a1:=Zero;
while p1^[a1] <> Zero do
Inc(a1);
Result:=a1; end else
Result:=Zero;
end;
  // Знак в целое число >
function ChrToByte(Value: Char): Byte;
begin
case Value of
'0': Result:=Zero;
'1': Result:=One;
'2': Result:=Two;
'3': Result:=Three;
'4': Result:=Four;
'5': Result:=Five;
'6': Result:=Six;
'7': Result:=Seven;
'8': Result:=Eight;
'9': Result:=Nine;
else Result:=Zero; end;
end;
  // Степень десятки >
function PowerOfTen(Value: Cardinal): Cardinal;
var a1:Cardinal;
begin
if Value = Zero then
Result:=One else begin
Result:=One;
for a1:=One to Value do
Result:=Result*Ten; end;
end;
  // Строку в целое число >
function StrToCardinal(Value: String): Cardinal;
var a1,a2:Cardinal;
begin
a2:=Length(Value);
if a2 = Zero then
Result:=Zero else
if a2 = One then
Result:=ChrToByte(Value[One]) else begin
Result:=ChrToByte(Value[One]);
for a1:=Two to a2 do
Result:=Result+ChrToByte(Value[a1])*PowerOfTen(a1-One); end;
end;
  // Експорт собственной памяти >
function ExGetMem(Size: Cardinal): Pointer; stdcall;
begin
GetMem(Result,Size);
end;
  // Заполняем константами >
procedure FillWithOne(pData: PMy4f);
var a1:Cardinal;
begin
for a1:=Zero to Three do
pData^[a1]:=One;
end;
  // Заполняем константами >
procedure FillWithOne(pData: PMy3f);
var a1:Cardinal;
begin
for a1:=Zero to Two do
pData^[a1]:=One;
end;
  // Обнулить эту память >
procedure FillWithZero(pData: Pointer; Size: Cardinal);
begin
FillChar(pData^,Size,Zero);
end;
  // Возвращает имя пускателя >
function GetExeName: String;
begin
Result:=ParamStr(Zero);
end;
  // Это еще пригодится не только сдесь, в этом модуле >
procedure DoNothing;
begin
{Пусто}
end;
  // Так-же но не совсем >
procedure DoNothingSTD; stdcall;
begin
{Пусто}
end;
  // Разделяет две строчки "слЭшом", если надо >
function SlashSep(Part1,Part2: String): String;
begin
if Part1[Length(Part1)] <> mnSlash then
Result:=Part1 + mnSlash + Part2 else
Result:=Part1 + Part2;
end;
  // Извлечь из адреса путь к файлу >
function ExtractFilePath(Value: String): String;
var a1:Integer;
begin
a1:=Length(Value);
if a1 > Zero then
while (Value[a1] <> mnSlash) and (Value[a1] <> mnBeckSlash) and (a1 <> Zero) do
Dec(a1);
if a1 < One then
Result:=Value else
Result:=Copy(Value,One,a1);
end;
  // Извлечь разрешение файла >
function ExtractFileExt(Value: String): String;
var a1,a2:Cardinal; s1,s2:String;
begin
s1:=EmptyString;
a1:=Length(Value);
for a2:=a1 downto One do
s1:=s1+Value[a2];
a1:=Pos(mnDot,s1);
s1:=Copy(s1,One,a1-One);
s2:=EmptyString;
a1:=Length(s1);
for a2:=a1 downto One do
s2:=s2+s1[a2];
Result:=s2;
end;
  // Извлечь из адреса имя файла >
function ExtractFileName(Value: String): String;
var a1,a2:Integer;
begin
a2:=Length(Value);
a1:=a2;
if a1 > Zero then
while (Value[a1] <> mnSlash) and (Value[a1] <> mnBeckSlash) and (a1 > Zero) do
Dec(a1);
if a1 > Zero then
Result:=Copy(Value,a1 + One,a2 - a1) else
Result:=EmptyString;
end;
  // Извлечь из адреса само имя файла без расширения и пути >
function ExtractFileNameOnly(Value: String): String;
var a1,a2,a3:Integer;
begin
Result:=EmptyString;
a3:=Length(Value);
a2:=a3;
if a3 > Zero then begin
a1:=a3;
while (Value[a1] <> mnDot) and (a1 >= Zero) do
Dec(a1);
if a1 > One then
a2:=a1;
while (Value[a2] <> mnSlash) and (Value[a2] <> mnBeckSlash) and (a2 >= Zero) do
Dec(a2);
if (a1 < One) and (a2 < One) then
Result:=Value else
if (a1 < One) and (a2 > Zero) then
Result:=Copy(Value,a2 + One,a3 - a2) else
if (a1 > Zero) and (a2 < One) then
Result:=Copy(Value,One,a1 - One) else
if (a1 > Zero) and (a2 > Zero) and (a1 > a2) then
Result:=Copy(Value,a2 + One,a1 - a2 - One); end;
end;
  // Вместо того, что в SysUtils >
function IntToStr(Value: Integer): String;
begin
Str(Value,Result);
end;
  // Ещё одна подстава ;) >
function StrToInt(const S: string): Integer;
var a1: Integer;
begin
Val(S,Result,a1);
if a1 <> Zero then
Result:=Zero;
end;
  // "Мелкие" буквы в "большие" >
function UpperCase(Value: String): String;
var a1,a2:Cardinal;
begin
a2:=Length(Value);
if a2 = Zero then
Result:=EmptyString else begin
SetLength(Result,a2);
for a1:=One to Length(Value) do
case Byte(Value[a1]) of
One..127:   Result[a1]:=UpCase(Value[a1]);
$E0..$FF: Result[a1]:=Chr(byte(Value[a1]) - _32);
$B3:      Result[a1]:=Chr($B2); // Украинские символы >
$BF:      Result[a1]:=Chr($AF);
$B4:      Result[a1]:=Chr($A5);
$B8:      Result[a1]:=Chr($A8); // буква ё >
else      Result[a1]:=Value[a1]; end; end;
end;
//=============================================================================>
//============================== 3D МАТЕМАТИКА ================================>
//=============================================================================>
function SegmentLength(var v1,v2: TMyVector3f): Single;
begin // Вычисляем длинну отрезка (Length of segment) >
Result:=Sqrt(Sqr(v2[_X]-v1[_X])+Sqr(v2[_Y]-v1[_Y])+Sqr(v2[_Z]-v1[_Z]));
end;
  // Вычисляем длинну вектора (Length of vector) >
function VectorLength(var v1: TMyVector3f): Single;
begin
Result:=Sqrt(Sqr(v1[_X])+Sqr(v1[_Y])+Sqr(v1[_Z]));
end;
  // Сложение двух векторов (Addition of two vectors) >
function VectorSum(var v1,v2: TMyVector3f): TMyVector3f;
begin
Result[_X]:=v1[_X]+v2[_X];
Result[_Y]:=v1[_Y]+v2[_Y];
Result[_Z]:=v1[_Z]+v2[_Z];
end;
  // Умножение вектора на число (Vector multiplication) >
function VectorMultiplication(var Vector: TMyVector3f; Value: Single): TMyVector3f;
begin
Result[_X]:=Vector[_X]*Value;
Result[_Y]:=Vector[_Y]*Value;
Result[_Z]:=Vector[_Z]*Value;
end;
  // Скалярное произведение двух векторов (scalar multiplication \ dot product) >
function DotProduct(var v1,v2: TMyVector3f): Single;
begin
Result:=v1[_X]*v2[_X]+v1[_Y]*v2[_Y]+v1[_Z]*v2[_Z];
end;
  // Векторное произведение двух векторов (vector multiplication \ cross product) >
function CrossProduct(var v1,v2: TMyVector3f): TMyVector3f;
begin
Result[_X]:=v1[_Y]*v2[_Z]-v1[_Z]*v2[_Y];
Result[_Y]:=v1[_Z]*v2[_X]-v1[_X]*v2[_Z];
Result[_Z]:=v1[_X]*v2[_Y]-v1[_Y]*v2[_X];
end;
  // Сложение двух матриц (addition) >
function MatrixSum(var v1,v2: TMyMatrix3x3f): TMyMatrix3x3f;
begin
Result[_X,_X]:=v1[_X,_X]+v2[_X,_X];
Result[_X,_Y]:=v1[_X,_Y]+v2[_X,_Y];
Result[_X,_Z]:=v1[_X,_Z]+v2[_X,_Z];
Result[_Y,_X]:=v1[_Y,_X]+v2[_Y,_X];
Result[_Y,_Y]:=v1[_Y,_Y]+v2[_Y,_Y];
Result[_Y,_Z]:=v1[_Y,_Z]+v2[_Y,_Z];
Result[_Z,_X]:=v1[_Z,_X]+v2[_Z,_X];
Result[_Z,_Y]:=v1[_Z,_Y]+v2[_Z,_Y];
Result[_Z,_Z]:=v1[_Z,_Z]+v2[_Z,_Z];
end;
  // Умножение матрицы на число (multiplication of matrix by scalar) >
function MatrixMultiplication(var Matrix: TMyMatrix3x3f; Value: Single): TMyMatrix3x3f;
begin
Result[_X,_X]:=Matrix[_X,_X]*Value;
Result[_X,_Y]:=Matrix[_X,_Y]*Value;
Result[_X,_Z]:=Matrix[_X,_Z]*Value;
Result[_Y,_X]:=Matrix[_Y,_X]*Value;
Result[_Y,_Y]:=Matrix[_Y,_Y]*Value;
Result[_Y,_Z]:=Matrix[_Y,_Z]*Value;
Result[_Z,_X]:=Matrix[_Z,_X]*Value;
Result[_Z,_Y]:=Matrix[_Z,_Y]*Value;
Result[_Z,_Z]:=Matrix[_Z,_Z]*Value;
end;
//=============================================================================>
//================================= Конец модуля ==============================>
//=============================================================================>
end.
