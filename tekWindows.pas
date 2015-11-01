{===============================================================================
Зависимый от "Windows" модуль без инициализации
Источник: kernel32.dll,user32,advapi32.dll
===============================================================================}
unit tekWindows; // 9.3.2011 >
//=============================================================================>
//=============================== Раздел обьявлений ===========================>
//=============================================================================>
interface
  // Только независимые или Windows-зависимые модули! >
uses tekSystem,Windows,Messages;
//=============================================================================>
//================================= Константы =================================>
//=============================================================================>
const
  INVALID_HANDLE = INVALID_HANDLE_VALUE;
  INVALID_HV = INVALID_HANDLE;
//=============================================================================>
//==================================== Типы ===================================>
//=============================================================================>
type
    // Тип для  >
  PMyTime = ^TMyTime;
  TMyTime = record
    wYear: Word;
    bMonth: Byte;
    bDay: Byte;
    bHour: Byte;
    bMinute: Byte;
    bSecond: Byte;
  end;
    // Для колупания в системных функциях >
  PMyParamString = ^TMyParamString;
  TMyParamString = array [Zero..MAX_PATH-One] of Char;
    // Это для параметров типа lpAnsiChar >
  PMySystemPath = PMyParamString;
  TMySystemPath = TMyParamString;
    // Заимствовано из SysUtils >
  PLPack = ^TLPack; // Для дальнейшего расширения в Сишном ванианте 8) - универсальность! >
  TLPack = packed record
    case Integer of
      Zero:(Lo,Hi: Word);
      One:(Words: array [Zero..One] of Word);
      Three:(Bytes: array [Zero..Three] of Byte);
  end;
    // Местное название >
  LongRec = TLPack;
    // Расширяемость, - возможно 8) >
  PSearchRec = ^TSearchRec;
  TSearchRec = record // Заимствовано из SysUtils >
    Time: Integer;
    Size: Integer;
    Attr: Cardinal;
    Name: String;
    ExcludeAttr: Cardinal;
    FindHandle: Cardinal;
    FindData: TWin32FindData;
  end;
    // Тип процедуры обработчика оконных сообщений от Windows >
  PWindowProc = ^TWindowProc;
  TWindowProc = function(hWnd,uMsg: Cardinal; wParam,lParam: Integer): Integer; stdcall;
//=============================================================================>
//================================= Константы =================================>
//=============================================================================>
const
    // Файловые флаги (SysUtils) >
  faHidden = $00000002 platform;
  faSysFile = $00000004 platform;
  faVolumeID = $00000008 platform;
  faDirectory = $00000010;
  faAnyFile = $0000003F;
  faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;
  faUsual = not faAnyFile and faSpecial;
  cBitmapInfoSize = SizeOf(TBitMapInfo);
  cBitmapInfoHeaderSize = SizeOf(TBitmapInfoHeader);
    // Нормальный BitMap >
  mnBMP = $4D42;
    // Привелегии >
  mnDebug = 'SeDebugPrivilege';
  mnShutdown = 'SeShutdownPrivilege';
  mniDebug = One;
  mniShutdown = Two;
//=============================================================================>
  function SetFileValidData(hFile: Cardinal; ValidDataLength: LongLong): Bool; external kernel32;
//=============================================================================>
//=========================== Функциональность модуля =========================>
//=============================================================================>
  procedure ShowMessage(Value: String); overload;
  procedure ShowMessage(Value: Integer); overload;
  procedure DeleteByBat(Adress: String);
  procedure UpDatePMyTime(var pData: PMyTime);
  procedure BeeBeep;
  function GetDiskFreeSpaceEx(Directory: PChar; var FreeAvailable,TotalSpace: TLargeInteger; TotalFree: PLargeInteger): Bool stdcall; external kernel32 name 'GetDiskFreeSpaceExA';
  function SaveToMappedFile(pPath: PChar; pData: Pointer; Size: Cardinal): Boolean;
  function LoadFromMappedFile(pPath: PChar; var pData: Pointer; var Size: Cardinal): Boolean;
  function FileSize(pPath: PChar): Int64;
  function FileExists(Path: String): Boolean; overload;
  function FileExists(pPath: PChar): Boolean; overload;
  function FindMatchingFile(pData: PSearchRec): Cardinal;
  function AskQuestionYesNo(sHeader,sValue: String): Boolean;
  function SetMonitorState(State: Boolean): Boolean;
  function RunThreadedFunction(pData: PMyTHreadedFunction): Boolean;
  function GetStartButtonHandle: Cardinal;
  function ChangeScreenSet(Width,Height,ColorDepth,Frequency: Cardinal): Boolean;
  function ChangeScreenSetBack: Boolean;
  function GetWindowsUserName: String;
  function GetMyPrivilege(PrivilegeName: String; aEnabled: Boolean): boolean;
  function ActivateMyPrivilege(nType: Cardinal; State: Boolean): Boolean;
  function TerminateProcByPID(ProcID: Cardinal): Boolean;
  function MyWindowsExit(uFlags: Cardinal): Boolean;
  function MyFileSize(Adress: String): Cardinal;
  function GetWindowsError: String;
  function SetPriority(Value: Cardinal): Boolean;
  function MyLoadLibrary(pPath: Pchar; var libHandle: Cardinal): Boolean;
  function MyGetProcAddress(var libHandle: Cardinal; var pProcPointer: Pointer; pProcName: PChar): Boolean;
  function LunchProgram(Path: PChar = nil; WaitTermination: Boolean = false): Boolean;
//=============================================================================>
//============================= Раздел реализации =============================>
//=============================================================================>
implementation
  // Загрузка библиотеки с проверкой >
function MyLoadLibrary(pPath: Pchar; var libHandle: Cardinal): Boolean;
begin
if Assigned(pPath) then
if FileExists(pPath) then
libHandle:=LoadLibrary(pPath) else
libHandle:=INVALID_HV else
libHandle:=INVALID_HV;
Result:=libHandle <> INVALID_HV;
end;
  // Загрузка точки входа в функцию из библиотеки >
function MyGetProcAddress(var libHandle: Cardinal; var pProcPointer: Pointer; pProcName: PChar): Boolean;
begin
if libHandle = INVALID_HV then
pProcPointer:=nil else
pProcPointer:=GetProcAddress(libHandle,pProcName);
Result:=Assigned(pProcPointer);
end;
  // Запустить программу по указанному адресу... >
function LunchProgram(Path: PChar = nil; WaitTermination: Boolean = false): Boolean;
var SI:TStartupInfo; PI:TProcessInformation; a1:Cardinal;
begin
a1:=SizeOf(SI);
FillWithZero(@SI,a1);
SI.cb:=a1;
if Path = nil then
Path:=PChar(GetExeName);
Result:=CreateProcess(nil,Path,nil,nil,false,Zero,nil,nil,SI,PI);
if Result and WaitTermination then
WaitforSingleObject(PI.hProcess,INFINITE); //while GetExitCodeProcess(PI.hProcess,a1) and (a1 = STILL_ACTIVE) do // Sleep(_128);
end;
  // Обновить время... >
procedure UpDatePMyTime(var pData: PMyTime);
var v1:TSystemTime;
begin
if not Assigned(pData) then
New(pData);
GetSystemTime(v1);
with pData^ do begin
wYear:=v1.wYear;
bMonth:=v1.wMonth;
bDay:=v1.wDay;
bHour:=v1.wHour;
bMinute:=v1.wMinute;
bSecond:=v1.wSecond; end;;
end;
  // Установка приоритета для текщего процесса >
function SetPriority(Value: Cardinal): Boolean;
begin
case Value of
Zero: Result:=SetPriorityClass(GetCurrentProcess,IDLE_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_IDLE);
One: Result:=SetPriorityClass(GetCurrentProcess,IDLE_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_LOWEST);
Two: Result:=SetPriorityClass(GetCurrentProcess,NORMAL_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_BELOW_NORMAL);
Three: Result:=SetPriorityClass(GetCurrentProcess,NORMAL_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_NORMAL);
Four: Result:=SetPriorityClass(GetCurrentProcess,NORMAL_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_ABOVE_NORMAL);
Five: Result:=SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_HIGHEST);
Six: Result:=SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_TIME_CRITICAL);
else Result:=false; end;
end;
  // Текстовая форма последней ошибки в винде >
function GetWindowsError: String;
var p1:Pointer;
begin
GetMem(p1,mnKB);
if FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,nil,GetLastError,GetKeyboardLayout(Zero),p1,mnKB,nil) = Zero then
Result:=UnKnownError else
Result:=String(p1^);
FreeMem(p1,mnKB);
end;
  // Узнать размер файла в байтах >
function MyFileSize(Adress: String): Cardinal;
var a1:Cardinal; a2:TWin32FindData;
begin
a1:=FindFirstFile(PChar(Adress),a2);
if a1 = INVALID_HANDLE_VALUE then
Result:=Zero else begin
Result:=a2.nFileSizeLow;
FindClose(a1); end;
end;
  // Создает "BAT"-файл который хочет что-то стереть >
procedure DeleteByBat(Adress: String);
var F:TextFile; s1:String; ProcessInformation:TProcessInformation; StartupInformation:TStartupInfo;
begin
if FileExists(Adress) then begin
s1:=Adress + '.bat'; // создаём бат-файл в директории приложения >
AssignFile(F,s1); // открываем и записываем в файл >
Rewrite(F); // Перезаписываем файл >
Writeln(F,':try'); // Это метка с которой начинается >
Writeln(F,'del "' + Adress + '"'); // удаление по адресу >
Writeln(F,'if exist "' + Adress + '"' + ' goto try'); // если всееще этот адрес доступен >
Writeln(F,'del "' + s1 + '"'); // возвращаемся к метке >
CloseFile(F); // Закрываем файл >
FillChar(StartUpInformation,SizeOf(StartUpInformation),$00);
StartUpInformation.dwFlags:=STARTF_USESHOWWINDOW;
StartUpInformation.wShowWindow:=SW_HIDE;
if CreateProcess(nil,PChar(s1),nil,nil,False,IDLE_PRIORITY_CLASS,nil,nil,StartUpInformation,ProcessInformation) then begin // Включаем рубатель "втихушку" >
CloseHandle(ProcessInformation.hThread);
CloseHandle(ProcessInformation.hProcess); end; end;
end;
  // Для завершения сессии "Винды" >
function MyWindowsExit(uFlags: Cardinal): Boolean;
begin
if ActivateMyPrivilege(One,true) then begin
Result:=ExitWindowsEx(uFlags,Zero);
ActivateMyPrivilege(One,false) end else
Result:=false;
end;
  // Остановить процесс привелегией отладки >
function TerminateProcByPID(ProcID: Cardinal): Boolean;
var a1:Cardinal;
begin
if ActivateMyPrivilege(mniDebug,true) then begin
a1:=OpenProcess(PROCESS_TERMINATE,false,ProcID); // Получаем дескриптор процесса для его завершения >
if a1 <> Zero then begin
Result:=TerminateProcess(a1,Cardinal(-One)); // Завершаем процесс >
CloseHandle(a1); end else
Result:=false;
ActivateMyPrivilege(mniDebug,false); end else
Result:=false;
end;
  // Включить некоторую привелегию >
function ActivateMyPrivilege(nType: Cardinal; State: Boolean): Boolean;
begin
case nType of
mniDebug: Result:=GetMyPrivilege(mnDebug,State);
mniShutdown: Result:=GetMyPrivilege(mnShutdown,State);
else Result:=false; end;
end;
  // Получить привелегию >
function GetMyPrivilege(PrivilegeName: String; aEnabled: Boolean): boolean;
var TPPrev,TP:TTokenPrivileges; Token,dwRetLen: Cardinal;
begin
if OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,Token) then begin
TP.PrivilegeCount:=One;
if LookupPrivilegeValue(nil,PChar(PrivilegeName),TP.Privileges[Zero].LUID) then begin
if aEnabled then
TP.Privileges[Zero].Attributes:=SE_PRIVILEGE_ENABLED else
TP.Privileges[Zero].Attributes:=Zero;
dwRetLen:=Zero;
Result:=AdjustTokenPrivileges(Token,false,TP,SizeOf(TPPrev),TPPrev,dwRetLen) and (GetLastError = NO_ERROR); end else
Result:=false;
CloseHandle(Token); end else
Result:=false;
end;
  // Узнаем чья сейчас сессия винды >
function GetWindowsUserName: String;
var s1:String; c1:Cardinal;
begin
c1:=ByteMax; // Максимум длинны имени пользователя >
SetLength(s1,c1); // Устанавливаем принятую длинну >
if GetUserName(PChar(s1),c1) then // Если шото с именем перепало, то >
Result:=Copy(s1,One,c1 - One) else // запоминаем это имя >
Result:=EmptyString; // нет - тоже запоминаем >
end;
  // Для смены экранного режима >
function ChangeScreenSet(Width,Height,ColorDepth,Frequency: Cardinal): Boolean;
var ScreenSet: TDeviceMode;
begin
FillWithZero(@ScreenSet,SizeOf(TDeviceMode)); // Все значения заполняем нулями >
with ScreenSet do try
dmSize:=SizeOf(TDeviceMode);
if Width > Zero then begin // Если указана ширина >
dmPelsWidth:=Width;
dmFields:=dmFields or DM_PELSWIDTH; end;
if Height > Zero then begin // Высота >
dmPelsHeight:=Height;
dmFields:=dmFields or DM_PELSHEIGHT; end;
if ColorDepth > Zero then begin // глубина цвета >
dmBitsPerPel:=ColorDepth;
dmFields:=dmFields or DM_BITSPERPEL; end;
if Frequency > Zero then begin // Частота обновления/развертки экрана >
dmDisplayFrequency:=Frequency;
dmFields:=dmFields or DM_DISPLAYFREQUENCY; end;
if dmFields = Zero then
Result:=true else
Result:=ChangeDisplaySettings(ScreenSet,CDS_FULLSCREEN) = DISP_CHANGE_SUCCESSFUL; except
Result:=false; end;
end;
  // Вернуть в исходные (по данным регистра) настройки экрана >
function ChangeScreenSetBack: Boolean;
begin
Result:=ChangeDisplaySettings(DevMode(nil^),Zero) = DISP_CHANGE_SUCCESSFUL;
end;
  // Получаем "держак" к кнопке "пуск" >
function GetStartButtonHandle: Cardinal;
begin
Result:=FindWindow('Shell_TrayWnd',nil);
if Result <> mgl_Zero then
Result:=FindWindowEx(Result,mgl_Zero,'Button',nil);
end;
  // Запустить функцию в отдельном потоке >
function RunThreadedFunction(pData: PMyTHreadedFunction): Boolean;
var mThreadID:Cardinal;
begin
Result:=CreateThread(nil,Zero,pData,nil,Zero,mThreadID) <> Zero;
end;
  // Выключить монитор >
function SetMonitorState(State: Boolean): Boolean;
begin
if State then
Result:=SendMessage(GetStartButtonHandle,WM_SYSCOMMAND,SC_MONITORPOWER,One) <> mgl_Zero else
Result:=SendMessage(GetStartButtonHandle,WM_SYSCOMMAND,SC_MONITORPOWER,mgl_Zero) <> mgl_Zero;
end;
  // Задать вопрос: "Да или Нет?" >
function AskQuestionYesNo(sHeader,sValue: String): Boolean;
begin
Result:=MessageBox(Zero,PChar(sValue),PChar(sHeader),mb_YesNo + mb_IconQuestion + mb_TaskModal) = idYes;
end;
  // Просто, тупо - показать сообщение >
procedure ShowMessage(Value: String); overload;
begin
MessageBox(Zero,PChar(Value),mnMessageRus,MB_OK);
end;
  // Показать "цифровое" сообщение >
procedure ShowMessage(Value: Integer); overload;
begin
MessageBox(Zero,PChar(IntToStr(Value)),mnMessageRus,MB_OK);
end;
  // Это всё-равно спиЖЖэно, так-что пока рана оправдываться 8(( >
function FindMatchingFile(pData: PSearchRec): Cardinal;
var LocalFileTime: TFileTime;
begin
with pData^ do begin
while FindData.dwFileAttributes and ExcludeAttr <> Null do
if not FindNextFile(FindHandle,FindData) then begin
Result:=GetLastError;
Exit; end;
FileTimeToLocalFileTime(FindData.ftLastWriteTime,LocalFileTime);
FileTimeToDosDateTime(LocalFileTime,LongRec(Time).Hi,LongRec(Time).Lo);
Size:=FindData.nFileSizeLow;
Attr:=FindData.dwFileAttributes;
Name:=FindData.cFileName; end;
Result:=Zero;
end;
  // Есть-ли такой файл или каталог ? >
function FileExists(Path: String): Boolean; overload;
var a1:Cardinal; a2:Integer; a3:TWin32FindData; a4:TFileTime;
begin
a1:=FindFirstFile(PChar(Path),a3);
if a1 = INVALID_HANDLE_VALUE then
Result:=false else begin
FindClose(a1);
FileTimeToLocalFileTime(a3.ftLastWriteTime,a4);
if FileTimeToDosDateTime(a4,TLPack(a2).Hi,TLPack(a2).Lo) then
Result:=a2 <> - One else
Result:=false;  end;
end;
  // Ещё версия 8) >
function FileExists(pPath: PChar): Boolean; overload;
var a1:Cardinal; a2:Integer; a3:TWin32FindData; a4:TFileTime;
begin
a1:=FindFirstFile(pPath,a3);
if a1 = INVALID_HANDLE_VALUE then
Result:=false else begin
FindClose(a1);
FileTimeToLocalFileTime(a3.ftLastWriteTime,a4);
if FileTimeToDosDateTime(a4,TLPack(a2).Hi,TLPack(a2).Lo) then
Result:=a2 <> - One else
Result:=false;  end;
end;
  // Размер файла >
function FileSize(pPath: PChar): Int64;
var a1:Cardinal; a2:Integer; a3:TWin32FindData; a4:TFileTime;
begin
a1:=FindFirstFile(pPath,a3);
if a1 = INVALID_HANDLE_VALUE then
Result:=Zero else begin
FindClose(a1);
FileTimeToLocalFileTime(a3.ftLastWriteTime,a4);
if FileTimeToDosDateTime(a4,TLPack(a2).Hi,TLPack(a2).Lo) then
if a2 <> - One then
Result:=a3.nFileSizeLow or a3.nFileSizeHigh shl _32 else
Result:=Zero else
Result:=Zero; end;
end;
  // Загрузить отображением >
function LoadFromMappedFile(pPath: PChar; var pData: Pointer; var Size: Cardinal): Boolean;
var c1,c2,c3,c4:Cardinal; p1:Pointer;
begin
c1:=CreateFile(pPath,GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,Zero);
if c1 = Zero then
Result:=false else begin
c3:=GetFileSize(c1,@c4); // Странный "nil" >
if c3 = Zero then begin
pData:=nil;
Size:=Zero;
Result:=true; end else begin
c2:=CreateFileMapping(c1,nil,PAGE_READONLY,Zero,c3,@c4);
if c2 = Zero then
Result:=false else begin
p1:=MapViewOfFile(c2,FILE_MAP_READ,Zero,Zero,c3);
if Assigned(p1) then try
GetMem(pData,c3);
Size:=c3;
Move(p1^,pData^,c3);
Result:=UnMapViewOfFile(p1); except
Result:=false; end else
Result:=false;
CloseHandle(c2); end; end;
CloseHandle(c1); end;
end;
  // Сохранить отображением >
function SaveToMappedFile(pPath: PChar; pData: Pointer; Size: Cardinal): Boolean;
var c1,c2:Cardinal; p1:Pointer;
begin
c1:=CreateFile(pPath,GENERIC_WRITE,Zero,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,Zero);
if c1 = Zero then
Result:=false else begin
c2:=CreateFileMapping(c1,nil,PAGE_READWRITE,Zero,Size,nil);
if c2 = Zero then
Result:=false else begin
p1:=MapViewofFile(c2,FILE_MAP_WRITE,Zero,Zero,Size);
if Assigned(p1) then try
Move(pData^,p1^,Size);
Result:=UnMapViewOfFile(p1); except
Result:=false; end else
Result:=false;
CloseHandle(c2); end;
CloseHandle(c1); end;
end;
  // >
procedure BeeBeep;
begin
Beep(1900,100);
end;
//=============================================================================>
//================================= Конец модуля ==============================>
//=============================================================================>
end.
