unit tekClasses; // 9.3.2011 >
//=============================================================================>
//=============================== Раздел обьявлений ===========================>
//=============================================================================>
interface
  // Использованные модули >
uses tekSystem,tekWindows,Windows;
//=============================================================================>
//==================================== Типы ===================================>
//=============================================================================>
type
    // Великий класс-предшественник ;) >
  TMyParent = class
    constructor Create(Value: Pointer = nil);
    destructor Destroy; override;
  private
    pClrVar: Pointer;
    pProperties: Pointer;
    mName: String;
    mType: Cardinal;
  public
    property Name: String read mName write mName;
    property MyType: Cardinal read mType write mType;
    property Properties: Pointer read pProperties write pProperties;
    property ClearValue: Pointer read pClrVar write pClrVar;
  end;
    // Поток (в смысле паралельный поток команд процесору) >
  TMyThread = class(TMyParent)
    constructor Create;
    destructor Destroy; override;
  private
    mThreadID: Cardinal;
    mStop: Boolean;
    procedure SetPriority(Value: Integer);
    function GetPriority: Integer;
  public
    property Stop: Boolean read mStop write mStop;
    property Priority: Integer read GetPriority write SetPriority;
    function OnTreadProcLine: Cardinal;
  end;
    // "Узел" >
  TMyNode = class(TMyParent)
    constructor Create;
    destructor Destroy; override;
    destructor DestroyAll;
  private
    mItems: array of TMyNode;
    mHigh: Integer;
    mCap: Cardinal;
    mParent: TMyNode;
    mNumber: Integer;
    pContainer: Pointer;
    mCount: Cardinal;
    mContainerType: Cardinal;
    function GetItem(Index: Cardinal): TMyNode;
    function SetCount(Value: Cardinal): Boolean;
    function GetCountAll: Cardinal;
    function GetFirst: TMyNode;
    function GetLast: TMyNode;
    function GetPreContainer: Pointer;
  public
    property Number: Integer read mNumber;
    property Parent: TMyNode read mParent;
    property Count: Cardinal read mCount;
    property CountAll: Cardinal read GetCountAll;
    property Capasity: Cardinal read mCap;
    property Items[Index: Cardinal]: TMyNode read GetItem;
    property Max: Integer read mHigh;
    property First: TMyNode read GetFirst;
    property Last: TMyNode read GetLast;
    property Container: Pointer read pContainer;
    property ContainerType: Cardinal read mContainerType write mContainerType;
    property PrePContainer: Pointer read GetPreContainer;
    function Add: TMyNode; overload;
    function Add(Value: TMyNode): Boolean; overload;
    function Remove(Index: Cardinal): Boolean;
    function Clear: Boolean;
    function ClearDestroy: Boolean;
    function ClearDestroyAll: Boolean;
    procedure Compress;
  end;
    // >
  TMyFileStream = class;
    // Настройки для "Предмета" >
  PMyItemPack = ^TMyItemPack;
  TMyItemPack = packed record
    mCreate: TMyTime; // Время создания >
    mView: TMyTime; // Время последнего просмотра >
    mEdit: TMyTime; // Время последнего изменения >
  end;
    // "Предмет" - это более подробный узел, приспособленный для пользователя >
  TMyItem = class(TMyNode)
    constructor Create;
    destructor Destroy; override;
  private
    pCreate: PMyTime; // Время создания >
    pView: PMyTime; // Время последнего просмотра >
    pEdit: PMyTime; // Время последнего изменения >
    mIPack: TMyItemPack; // Пакован настроек >
    pIPack: PMyItemPack; // Указатель на пакован >
  public
    property CreateTime: PMyTime read pCreate;
    property EditTime: PMyTime read pEdit;
    property ViewTime: PMyTime read pView;
    procedure UpDateViewTime; // Обновить время просмотра >
    procedure UpDateEditTime; // Обновить время редакции >
  end;
    // Обозреваемый предок >
  TMyExNo = class(TMyNode)
    constructor Create;
    destructor Destroy; override;
  private
    mPath: String;
    pPath: PChar;
    procedure SetPath(Value: String);
  public
    property Path: String read mPath write SetPath;
  end;
    // Свойства файла >
  PMyFileLinkParams = ^TMyFileLinkParams;
  TMyFileLinkParams = packed record
    mSize: Cardinal;
    mCreate: TMyTime;
    mEdit: TMyTime;
    mUse: TMyTime;
  end;
    // Упреждающее описание "каталога" >
  TMyFolderNode = class;
    // Упреждающее описание "диска\устройства" >
  TMyDriveNode = class;
    // Узел связанный с файлом >
  TMyFileNode = class(TMyExNo)
    constructor Create;
    destructor Destroy; override;
    destructor Delete;
  private
    mParams: TMyFileLinkParams;
  public
    function Exists: Boolean;
    function Execute: Boolean;
    function CopyTo(Value: TMyFolderNode; OverWrite: Boolean): Boolean; overload;
    function CopyTo(Value: TMyDriveNode; OverWrite: Boolean): Boolean; overload;
    function UpDate: Boolean; reintroduce;
    function UpDateAll: Boolean; reintroduce;
  end;
    // Узел связанный с каталогом >
  TMyFolderNode = class(TMyExNo)
    constructor Create;
    destructor Destroy; override;
    destructor Delete;
  private
    mParams: TMyFileLinkParams;
  public
    function Exists: Boolean;
    function CopyTo(Value: TMyFolderNode; OverWrite: Boolean): Boolean; overload;
    function CopyTo(Value: TMyDriveNode; OverWrite: Boolean): Boolean; overload;
    function CreateFolder(Value: String): TMyFolderNode;
    function UpDate: Boolean; reintroduce;
    function UpDateAll: Boolean; reintroduce;
  end;
    // Дополнительная информация по приводу\устройству\диску >
  PMyAdditionalDriveInfo = ^TMyAdditionalDriveInfo;
  TMyAdditionalDriveInfo = packed record
    FileSystemFlags: Cardinal; // Флаги файловой системмы >
    SerialNumber: Cardinal; // Серийный номер >
    FileSystem: String; // Название файловой системмы >
    BytesPerSector: Cardinal; // Байт в секторе >
    SectorsPerCluster: Cardinal; // Секторов в кластере >
    NumberOfFreeClusters: Cardinal; // Свободных кластеров >
    TotalNumberOfClusters: Cardinal; // Всего кластеров >
    DriveType: Cardinal; // Тип устройства носителя данного раздела\диска и т.д. >
  end;
    // Обычные свойства "диска" >
  PMyDriveParams = ^TMyDriveParams;
  TMyDriveParams = packed record
    FullSize: Int64; // Размер >
    FreeSize: Int64; // Свободно >
    UsedSize: Int64; // Занято >
    Name: String; // Имя\Метка\Название\ >
    Additional: TMyAdditionalDriveInfo; // Дополнительно >
  end;
    // Битовое полe, как 32 флага, короче 4 байта >
  TMyDrivesSet = set of Zero..mnMaxDrive;
    // Узел связанный с HDD\Floppy\CD\DVD\Flash диском >
  TMyDriveNode = class(TMyExNo)
    constructor Create(DriveChar: Char);
    destructor Destroy; override;
  private
    mDrivePack: TMyDriveParams;
    mDriveChar: Char;
    function GetLinkCheck: Boolean;
  public
    property LinkExists: Boolean read GetLinkCheck;
    property FullMemory: Int64 read mDrivePack.FullSize;
    property FreeMemory: Int64 read mDrivePack.FreeSize;
    property UsedMemory: Int64 read mDrivePack.UsedSize;
    function CreateFolder(Value: String): TMyFolderNode;
    function UpDate: Boolean; reintroduce;
    function UpDateAll: Boolean; reintroduce;
  end;
    // Для хранения только дисков >
  TMyDrivesNode = class(TMyExNo)
    constructor Create;
    destructor Destroy; override;
  public
    function UpDate: Boolean; reintroduce;
    function UpDateAll: Boolean; reintroduce;
  end;
    // Дополнительные сведения про винду 8)) >
  PMyWindowsAdditionalPack = ^TMyWindowsAdditionalPack;
  TMyWindowsAdditionalPack = packed record
    MajorVersion: Cardinal;
    MinorVersion: Cardinal;
    PlatformId: Cardinal;
    NucleusPath: String;
    Path: String;
  end;
    // Свойства текущей Windows >
  PMyWindowsPack = ^TMyWindowsPack;
  TMyWindowsPack = packed record
    CSDVersion: String;
    Build: Cardinal;
    Additional: TMyWindowsAdditionalPack;
  end;
    // Отвечает за винду и посылки к ней >
  TMyOSMSWindowsNode = class(TMyExNo)
    constructor Create;
    destructor Destroy; override;
  private
    mWindowsPack: TMyWindowsPack;
  public
    procedure UpDate;
  end;
    // Дополнительный пакован... >
  PMyAdditionalMemPack = ^TMyAdditionalMemPack;
  TMyAdditionalMemPack = packed record
    FreeMemory: Int64;
    FullMemory: Int64;
    UsedMemory: Int64;
  end;
    // Упаковка настроек для "оперативной памяти" >
  PMyRAMPack = ^TMyRAMPack;
  TMyRAMPack = packed record
    mPhisical: TMyAdditionalMemPack;
    mVirtual: TMyAdditionalMemPack;
    mPageFile: TMyAdditionalMemPack;
  end;
    // Класс для "оперативы" >
  TMyRAMNode = class(TMyExNo)
    constructor Create;
    destructor Destroy; override;
  private
    mRamPack: TMyRAMPack;
  public
    function UpDate: Boolean; reintroduce;
  end;
    // Узел связанный со всем компьютером\машиной >
  TMyComputerNode = class(TMyExNo)
    constructor Create;
    destructor Destroy; override;
  private
    mCPUSpeed: Single;
  public
    property CPUSpeed: Single read mCPUSpeed;
    function UpDate: Boolean; reintroduce;
    function UpDateAll: Boolean; reintroduce;
  end;
    // Виртуальный узел >
  TMyImageNode = class(TMyNode)
  private
    mFS: TMyFileStream;
    function GetFullPath: String;
  public
    property Path: String read GetFullPath;
  end;
    // Файловый пакован >
  TMyFileImagePack = packed record
    mSize: Int64;
    mFileType: Cardinal;
    mCreateTime: TFileTime;
    mViewTime: TFileTime;
    mEditTime: TFileTime;
  end;
    // Образ файла >
  TMyFileImage = class(TMyImageNode)
    constructor Create;
    destructor Destroy; override;
  private
    mPack: TMyFileImagePack;
    function GetCreateTime: TSystemTime;
    function GetViewTime: TSystemTime;
    function GetEditTime: TSystemTime;
    function GetExtension: String;
    function GetExists: Boolean;
    procedure WriteMe;
    procedure ReadMe;
  public
    property Size: Int64 read mPack.mSize;
    property FileType: Cardinal read mPack.mFileType;
    property CreateTime: TSystemTime read GetCreateTime;
    property ViewTime: TSystemTime read GetViewTime;
    property EditTime: TSystemTime read GetEditTime;
    property Extension: String read GetExtension;
    property Exists: Boolean read GetExists;
  end;
    // Образ каталога >
  TMyFolderImage = class(TMyImageNode)
    constructor Create;
    destructor Destroy; override;
  private
    function GetSize: Int64;
    function GetExists: Boolean;
    procedure WriteMe; reintroduce;
    procedure ReadMe; reintroduce;
  public
    property Size: Int64 read GetSize;
    property Exists: Boolean read GetExists;
  end;
    // Пакован образа диска >
  TMyDiskImagePack = packed record
    mFullSize: Int64; // Размер >
    mFreeSize: Int64; // Свободно >
    mUsedSize: Int64; // Занято >
    mFileSystemFlags: Cardinal; // Флаги файловой системмы >
    mSerialNumber: Cardinal; // Серийный номер >
    mBytesPerSector: Cardinal; // Байт в секторе >
    mSectorsPerCluster: Cardinal; // Секторов в кластере >
    mNumberOfFreeClusters: Cardinal; // Свободных кластеров >
    mTotalNumberOfClusters: Cardinal; // Всего кластеров >
    mDriveType: Cardinal; // Тип устройства носителя данного раздела\диска и т.д. >
    mCoverIndex: Cardinal; // Индекс обложки (может входить в название обложки и проигнорировано в этом поле) >
  end;
    // Образ диска >
  TMyDiskImage = class(TMyFolderImage)
    constructor Create(CharName: String);
    destructor Destroy; override;
  private
    mPack: TMyDiskImagePack;
    mCoverName: String; // Название обложки >
    mFileSystem: String; // Название файловой системмы >
    mLabel: String; // Метка >
    mOwner: String; // Владелец >
    mHolder: String; // Тот, у кого сейчас диск ;) >
  public
    property FullSize: Int64 read mPack.mFullSize;
    property FreeSize: Int64 read mPack.mFreeSize;
    property UsedSize: Int64 read mPack.mUsedSize;
    property Caption: String read mLabel;
    property FileSystemFlags: Cardinal read mPack.mFileSystemFlags;
    property SerialNumber: Cardinal read mPack.mSerialNumber;
    property FileSystem: String read mFileSystem;
    property BytesPerSector: Cardinal read mPack.mBytesPerSector;
    property SectorsPerCluster: Cardinal read mPack.mSectorsPerCluster;
    property NumberOfFreeClusters: Cardinal read mPack.mNumberOfFreeClusters;
    property TotalNumberOfClusters: Cardinal read mPack.mTotalNumberOfClusters;
    property DriveType: Cardinal read mPack.mDriveType;
    property CoverName: String read mCoverName write mCoverName;
    property CoverIndex: Cardinal read mPack.mCoverIndex write mPack.mCoverIndex;
    property Owner: String read mOwner write mOwner;
    property Holder: String read mHolder write mHolder;
    function SaveToFile(Path: String): Boolean;
    function LoadFromFile(Path: String): Boolean;
  end;
    // Класс-файл надстройка над "Windows API" >
  TMyFileStream = class(TMyParent)
    constructor Create; // Консруктор >
    destructor Destroy; override; // Деструктор >
  private // Вспомогательная часть >
    mHandle: Cardinal; // Файловый дескриптор >
    pPath: PChar; // Путь к файлу >
    pBuffer: Pointer; // Указатель на буффер >
    pPreBuffer: Pointer; // Указатель на укзатель на буффер >
    mBufferSize: Cardinal; // Размеры буффера >
    mBufferUsed: Cardinal; // сколько байт в буффере используется >
    mMapping: Cardinal; // Дескриптор отображения файла в память >
    mSystemGranularity: Cardinal; // Системная "гранулярность": величина, которой кратны страницы распределения\выдачи памяти >
    pBasePointer: Pointer; // Адрес полученного отображения файла в адресное пространство процесса >
    pCrntPointer: Pointer; // "Искомый адрес" в отображении >
    function GetPos: Int64; // Возвращает текущуюю позицию в файле (до и после 4гб)>
    procedure SetPos(Value: Int64); // Устанавливает текущую позицию в файле (до и после 4гб) >
    function GetSize: Int64; // Возвращает размеры файла (до и после 4гб) >
    procedure SetSize(Value: Int64); // Установить рамер файла >
    procedure SetBufferUsed(Value: Cardinal); // Установить, сколько буффера сейчас активно >
    function GetBufferString: String; // Пытается превратить содержимое буффера в строку и вернуть результатом %) >
    procedure SetBufferString(Value: String); // Записывает из строки в буффер >
  public // Функциональность >
    property FilePath: PChar read pPath;
    property Position: Int64 read GetPos write SetPos;
    property Size: Int64 read GetSize write SetSize;
    property Handle: Cardinal read mHandle;
    property Buffer: Pointer read pBuffer;
    property PreBuffer: Pointer read pPreBuffer;
    property BufferSize: Cardinal read mBufferSize;
    property BufferUsed: Cardinal read mBufferUsed write SetBufferUsed;
    property BufferString: String read GetBufferString write SetBufferString;
    property Mapping: Cardinal read mMapping;
    property SystemGranularity: Cardinal read mSystemGranularity;
    property BaseMapPointer: Pointer read pBasePointer;
    property CrntMapPointer: Pointer read pCrntPointer;
    function ActivateBuffer: Boolean; // Пометить весь буффер, как активный >
    function ClearBuffer: Boolean; // Заполнить память буффера нулями >
    function TakeFromBuffer(Size: Cardinal): Boolean; // Удалить из буффера столько-то байт, с таким-то сдвигом, после чего скопированная часть удаляется >
    function ExpandBufferFor(Size: Cardinal): Boolean; // Расширить буффер нa Size количество байт >
    function ExpandBufferUntil(Size: Cardinal): Boolean; // Расширить буффер до Size количество байт >
    function CopyToBuffer(pData: Pointer; Size: Cardinal): Boolean; // Скопировать в буффер данные, в случае нехватки памяти, он расширится сам >
    function CopyFromBuffer(pData: Pointer; Size: Cardinal): Boolean; // Скопировать данные избуффера куда-то >
    function ReSizeBuffer(Size: Cardinal): Boolean; // Переразметить буффер с сохранением "не использованных" данных >
    function ReBuildBuffer(Size: Cardinal): Boolean; // Пересоздать буффер без сохранения чего-бы-то-ни-было, что там было раньше >
    function DestroyBuffer: Boolean; // Освободить память из буффера >
    function OpenRead(Path: PChar): Boolean; // Открыть файл для чтения >
    function OpenWrite(Path: PChar): Boolean; // Открыть файл для записи >
    function CreateWrite(Path: PChar): Boolean; // Создать файл для записи >
    function OpenReadWrite(Path: PChar): Boolean; // Открыть файл для чтения и записи, а если его нет, то попытаться его создать >
    function CreateMapping(cSize: Int64 = Zero): Boolean; // Создать "объект отображения", в 64х-битной адрессации >
    function UnMap: Boolean; // Убить "объект-отображение" >
    function CreateView(cPosition,cCount: Int64): Boolean; // Отобразить "объект в память", в 64х-битной адрессации  >
    function UnView: Boolean; // Уничтожить отображение в память >
    function MapView(cPosition,cCount: Int64): Boolean;
    function UnViewMap: Boolean;
    function Close: Boolean; // Закрыть доступ к файлу >
    function CloseFull: Boolean; // Закрыть доступ к файлу >
    function Check: Boolean; // Проверка ликвидности дискриптора >
    function EndOfFile: Boolean; // Возвращает true если мы сейчас находимся в конце файла >
    function SetEndHere: Boolean; // Устанавливает конец файла в текущую позицию >
    function GoToBegin: Boolean; // Сдвинуться на начало файла (в нулевую позицию) >
    function GoToEnd: Boolean; // Сдвинуться на последнюю позицию в файле >
    function ReadAll: Boolean; overload; // Прочитать весь файл в буффер >
    function ReadLn(var Value: String): Boolean; // Прочитать строчку (для текстовых файлов) >
    function ReadAdd(Size: Cardinal): Boolean; // Прочитать, дописав полученные данные в буффер, который при необходимости расширится >
    function Read: Boolean; overload; // Прочитать в буффер столько данных, каков его(буффера) полный объём >
    function Read(var Value; Size: Cardinal): Boolean; overload;
    function Read(var pData: Pointer; Size: Cardinal): Boolean; overload;
    function Read(var Value: String): Boolean; overload;
    function Read(var pData: PChar): Boolean; overload;
    function Read(var Value: Cardinal): Boolean; overload;
    function Read(var Value: Integer): Boolean; overload;
    function Read(var Value: Word): Boolean; overload;
    function Read(var Value: Byte): Boolean; overload;
    function Read(var Value: Boolean): Boolean; overload;
    function Read(var Value: Single): Boolean; overload;
    function Read(var Value: Int64): Boolean; overload;
    function Read(var Value; nSize: Cardinal; nPosition: Int64): Boolean; overload;
    function ReadString: String;
    function ReadCardinal: Cardinal;
    function WriteLn(const Value: String): Boolean; // Записать строку (для текстовых файлов) >
    function Write: Boolean; overload; // Записать всё, что в буффере в файл >
    function Write(var Value; Size: Cardinal): Boolean; overload;
    function Write(var pData: Pointer; Size: Cardinal): Boolean; overload;
    function Write(const Value: String): Boolean; overload;
    function Write(var pData: PChar): Boolean; overload;
    function Write(var Value: Cardinal): Boolean; overload;
    function Write(var Value: Integer): Boolean; overload;
    function Write(var Value: Word): Boolean; overload;
    function Write(var Value: Byte): Boolean; overload;
    function Write(var Value: Boolean): Boolean; overload;
    function Write(var Value: Single): Boolean; overload;
    function Write(var Value: Int64): Boolean; overload;
    function Write(var Value; nSize: Cardinal; nPosition: Int64): Boolean; overload;
    function WriteCardinal(Value: Cardinal): Boolean;
  end;
    // Анимешные "настройки"\заголовок >
  PAnimeFilm = ^TAnimeFilm;
  TAnimeFilm = packed record
    Dramma: Byte;
    School: Byte;
    Shonen: Byte;
    Comedy: Byte;
    Psycho: Byte;
    Erotic: Byte;
    Parody: Byte;
    Porno: Byte;
    Adventures: Byte;
    NightMare: Byte;
    Romantic: Byte;
    Aoi: Byte;
    Hentai: Byte;
    Series: Word;
    Length: Word;
    Studio: TMyString64;
    Producer: TMyString64;
    Country: TMyString64;
    Comments: TMyString128;
    Describe: TMyString256;
    PicturePath: TMyString256;
    AnimePath: TMyString256;
  end;
    // WAV заголовок >
  PMyWAVHeader = ^TMyWAVHeader;
  TMyWAVHeader = packed record
    ChunkID: TMy4Char; // "RIFF" Заголовок
    ChunkSize: Cardinal; // Размер файла минус текущая позиция (минус восемь) >
    Format: TMy4Char; // "WAVE" ещё один заголовок >
    SubChunk1ID: TMy4Char; // "fmt " подзаголовок "куска" >
    SubChunk1Size: Cardinal; // 16 for PCM.  This is the size of the rest of the Subchunk which follows this number. >
    AudioFormat: Word; // PCM = 1 (несжатый = 1) >
    NumChannels: Word; // Количество каналов: Моно = 1, Стерео = 2 и т.д. >
    SampleRate: Cardinal; // Частота: 8000, 44100 и т.д. >
    ByteRate: Cardinal; // ByteRate = SampleRate*NumChannels*BitsPerSample/8 >
    BlockAlign: Word; // BlockAlign = NumChannels*BitsPerSample/8 >
    BitsPerSample: Word; // 8 bits = 8, 16 bits = 16, etc. >
    SubChunk2ID: TMy4Char; // "data" подзаголовок для последнего "куска" за которым уже хранятся звуковые данные >
    SubChunk2Size: Cardinal; // Размер звуковых данных (SubChunk2Size = SampleRate*NumChannels*BitsPerSample/8) >
  end;
    // Файловый поток для WAV-файлов >
  TMyWAVStream = class(TMyFileStream)
    constructor Create;
    destructor Destroy; override;
  private
     mWAVHeader: TMyWAVHeader;
     pWAVHeader: PMyWAVHeader;
     function WriteHeader: Boolean;
     procedure SetHeader(pData: PMyWAVHeader);
  public
    property PWAV: PMyWAVHeader read pWAVHeader write SetHeader;
    function Check: Boolean; reintroduce;
    function WriteWAVData(var pData: Pointer; Size: Cardinal): Boolean;
    function OpenRead(Path: PChar): Boolean; reintroduce;
    function OpenWrite(Path: PChar): Boolean; reintroduce;
    function ReadAll: Boolean; reintroduce;
  end;
    // Узел для чтения/записи специальных зашифрованных текстовых файлов >
  TMyStringList = class(TMyFileStream)
    constructor Create;
    destructor Destroy; override;
  private
    mStrings: TMyStrings;
    mStringsCount: Cardinal;
    mStringsHigh: Integer;
    mStringsCap: Cardinal;
    mStringsCrnt: Integer;
    mCharCodes: array [Byte] of Boolean;
    mDividorCodes: array [Byte] of Boolean;
    function SetStrCount(Value: Cardinal): Boolean;
    function GetLine(Index: Cardinal): String;
    procedure SetLine(Index: Cardinal; Value: String);
    function GetFirst: String;
    function GetNext: String;
    function GetLast: String;
    function GetThis: String;
  public
    property Line[Index: Cardinal]: String read GetLine write SetLine;
    property Count: Cardinal read mStringsCount;
    property Max: Integer read mStringsHigh;
    property Capasity: Cardinal read mStringsCap;
    property First: String read GetFirst;
    property This: String read GetThis;
    property Next: String read GetNext;
    property Last: String read GetLast;
    function Add(const Value: String): Boolean; overload;
    function Add(const Value: TMyStringList): Boolean; overload;
    function Remove(Index: Cardinal): Boolean;
    function Clear: Boolean;
    function IndexOf(Value: String): Integer;
    function Exchange(Index1,Index2: Cardinal): Boolean;
    procedure Skip(Value: Cardinal = One);
    function SaveToTextFile(Path: PChar): Boolean;
    function LoadFromTextFile(Path: PChar): Boolean;
    function Scan(Caption,Path: String): Boolean;
    procedure ScanRecurse(Caption, Path: String);
    function MakeCharCodes(mType: Cardinal; Line: String; Value: Boolean): Boolean;
    function StripStringToWords(const Value: String): Boolean;
    function StripTextFileToWords(Path: PChar): Boolean;
  end;
    // Лог - заодно переводчик и писатель 8) >
  TMyLog = class(TMyStringList)
    constructor Create(Path: String);
    destructor Destroy; override;
  private
    mFileName: String;
  public
    procedure WriteLog; overload;
    procedure WriteLog(Value: String); overload;
    procedure WriteLog(Index: Cardinal); overload;
    procedure WriteLog(Index,Value: Cardinal); overload;
    procedure WriteLog(Index: Cardinal; AdditionalValue: String); overload;
    procedure WriteLog(Index: Cardinal; AdditionalValue: String; Result: Boolean); overload;
    procedure WriteLog(Coment: String; Value: Integer); overload;
    procedure ClearLog;
  end;
  {
    // >
  TMyDiscImages = class(TMyStringList)
    constructor Create;
    destructor Destroy; override;
  private
    mWorkDirectory: String;
    procedure SetWorkDirectory(Value: String);
    function GetCount: Cardinal;
  public
    property WorkDirectory: String read mWorkDirectory write SetWorkDirectory;
  end;
  }
    // Загрузчик библиотек 8) >
  TMyLibModule = class(TMyStringList)
    constructor Create(Path: PChar);
    destructor Destroy; override;
  private
    mModuleHandle: Cardinal;
  public
    property Handle: Cardinal read mModuleHandle;
    function Check: Boolean; reintroduce;
    procedure SetEP(var pData: Pointer);
  end;
    // Общая часть для АБД >
  PMyHDMUsualPack = ^TMyHDMUsualPack;
  TMyHDMUsualPack = packed record
    Create: TMyTime;
    Edit: TMyTime;
    View: TMyTime;
    UseCount: Int64;
    UseType: Byte;
    Active: Boolean;
    InUse: Boolean;
    ParentNode: Int64;
  end;
    // Связь >
  PMyHDMLinkPack = ^TMyHDMLinkPack;
  TMyHDMLinkPack = packed record
    U: TMyHDMUsualPack;
    ParentLink: Int64;
    ChildLink: Int64;
    LinkedNodes: array [Byte] of Int64;
    LinkFlags: array [Byte] of Cardinal;
    LinkUsage: array [Byte] of Int64;
  end;
    // Описание узла >
  PMyHDMNodeDescription = ^TMyHDMNodeDescription;
  TMyHDMNodeDescription = packed record
    U: TMyHDMUsualPack;
    ParentDescription: Int64;
    ChildDescription: Int64;
    Size: Int64;
  end;
    // Узел >
  PMyHDMNodePack = ^TMyHDMNodePack;
  TMyHDMNodePack = packed record
    U: TMyHDMUsualPack;
    Nodes: array [Byte] of Int64;
    ParentIndex: SmallInt;
    Link: Int64;
    Description: Int64;
    Extra: Int64;
    Reserved: Int64;
  end;
    // Статистика >
  PMyHDMStatisticPack = ^TMyHDMStatisticPack;
  TMyHDMStatisticPack = packed record
    NodesAdded: Cardinal;
    LinksMade: Cardinal;
    DescriptionCreated: Cardinal;
    Views: Cardinal;
    Time: TMyTime;
    ParentPack: Int64;
    ChildPack: Int64;
  end;
    // Для спецификации по пользователям >
  PMyHDMAuthorisationPack = ^TMyHDMAuthorisationPack;
  TMyHDMAuthorisationPack = packed record
    Shift: Byte;
    Login: array [Byte] of Byte;
    Password: array [Byte] of Byte;
  end;
    // "Верховный" заголовок >
  PMyHDMHeaderPack = ^TMyHDMHeaderPack;
  TMyHDMHeaderPack = packed record
    FirstNode: TMyHDMNodePack;
    Authorisation: TMyHDMAuthorisationPack;
    StatisticBegin: Int64;
    StatisticEnd: Int64;
    EditionReserverd: array [Byte] of Int64;
  end;
    // Абстрактная база данных >
  TMyHardDriveDataTree = class(TMyFileStream)
    constructor Create;
    destructor Destroy; override;
  private
    mStatistic: TMyHDMStatisticPack;
    vAdditional1: TMyStringList;
    mNodesBuff: array of PMyHDMNodePack;
    mNodesBuffCount: Cardinal;
    mNodesBuffHigh: Integer;
    mNodesBuffCap: Cardinal;
    mNodesBuffDepth: Cardinal;
    mNodesScanRange: Cardinal;
    procedure ClearNode;
    procedure ClearLink;
    procedure ClearDescription;
    procedure ClearUsualPack;
    procedure ClearHeader;
    procedure NodeExtract(Value: Int64); overload;
    function NodeCount(Value: Int64): Int64; overload;
    procedure ClearNodesBuff;
    procedure SetNodeBuffCount(Value: Cardinal);
    function GetNodeBuff(Index: Cardinal): Pointer;
    function BeginUpDate: Boolean;
    procedure EndUpDate;
    procedure NodeGetNearestNames(Value: Int64); overload;
  public
    function Load(pPath: PChar = nil): Boolean;
    function Check: Boolean; reintroduce;
    function Clear: Boolean;
    function Close: Boolean; reintroduce;
    function NodeAdd(Value: String): Boolean; overload;
    function NodeAdd(Value: TMyStringList): Boolean; overload;
    function NodeCount: Int64; overload;
    function NodeExtract(Value: TMyStringList): Boolean; overload;
    function NodePath(Value: Int64): String;
    function NodePosition(Value: String): Int64;
    function NodeExists(Value: String): Boolean;
    function NodeParams(Value: Int64): PMyHDMNodePack;
    function NodeGetNearestNames(cNode: Int64; cList: TMyStringList; cCount: Cardinal = Zero): Boolean; overload;
    function LinkParams(Value: Int64): PMyHDMlinkPack;
    function Link(FirstNode,SecondNode: Int64): Boolean;
    function Linked(FirstNode,SecondNode: Int64): Boolean;
    function Links(cNode: Int64; cList: TMyStringList; cCount: Cardinal = Zero): Boolean;
    function LinksCount(cNode: Int64): Int64;
    function LastStatisticRecord: PMyHDMStatisticPack;
    function CrntStatisticRecord: PMyHDMStatisticPack;
  end;
//=============================================================================>
//================================= Константы =================================>
//=============================================================================>
const
  cUsualAudioBufferSize: Cardinal = _8192; // Стандартный размер для  >
  mWAVHeaderSize: Cardinal = SizeOf(TMyWAVHeader); // Размер заголовка *.WAV файла >
  cDriveParamsSize: Cardinal = SizeOf(TMyDriveParams); // Размер упаковки свойств для носителей памяти >
  cFileLinkParamsSize: Cardinal = SizeOf(TMyFileLinkParams); // Размер упаковки свойств для какого-то файла или каталога в реальной файловой системме или её образах и т.д. >
  cRAMPackSize: Cardinal = SizeOf(TMyRAMPack); // Размер упаковки свойств для оперативной памяти >
  mCPUDT = 100; // время измерения в миллисекундах, за которое мы будем считать такты >
  cWAV: String = 'WAV'; // Расширение для *.WAV-файлов >
  mRIFF: TMy4Char = 'RIFF'; // Зарезервированное начало заголовка >
  mR_WAV: TMy4Char = 'WAVE'; // Тип для несжатого звука >
  mR_DATA: TMy4Char = 'data'; // Это означает начала куска с данными >
  mR_SC1ID: TMy4Char = 'fmt'#$20; // Формат >
  mnCharTablePath: String = 'Chars.txt'; // Таблица\список кодов символов, которые являются буквенными, то есть кодируют буквы >
  mnLabelUnit: String = 'unit'; // Метка\зарезервированное слово, означающее начало модуля\куска программы описанного ввыделяющих метках\тэгах\зарезервированных словах >
  mnLabelUnitEnd: String = 'end.'; // Конец раздела реализации и всего модуля\кода\текста >
  mnLabelInterface: String = 'Interface'; // Начало раздела описаний >
  mnLabelImplementation: String = 'Implementation'; // Конец раздела описаний, начало раздела реализации >
  mnLabelUses: String = 'Uses'; // Использованые\мые модули >
  mnLabelConst: String = 'Const'; // Список констант >
  mnLabelType: String = 'Type'; // типов: новых структур, массивов, псевдонимов, классов, интерфейсов и т.д. и т.п. >
  mnLabelVar: String = 'Var'; // переменные >

  cMyHDMLinkPack = SizeOf(TMyHDMLinkPack);
  cMyHDMNodeDescription = SizeOf(TMyHDMNodeDescription);
  cMyHDMNodePack = SizeOf(TMyHDMNodePack);
  cMyHDMStatisticPack = SizeOf(TMyHDMStatisticPack);
  cMyHDMHeaderPack = SizeOf(TMyHDMHeaderPack);
    // Типы дисков >
  wdt_Unknown = Zero; // Неизвестен >
  wdt_dtNoDrive = One; // Отсутствует >
  wdt_dtFloppy = Two; // Флоппи >
  wdt_dtFixed = Three; // Жёсткий диск >
  wdt_dtNetwork = Four; // Сетевой\подключённый диск >
  wdt_dtCDROM = Five; // CD\DVD-ROM >
  wdt_dtRAM = Six; // Флешка и прочие сёмные носители >
    // Номера встроенных строк из лога >
  mnl_Start = _0; // Запуск программы >
  mnl_End = _1; // Остановка программы >
  mnl_Error = _2; // Ошибка >
  mnl_Message = _3; // Сообщение >
  mnl_STACK_UNDERFLOW = _4; // Потеря значимости стека >
  mnl_INVALID_ENUM = _5; // Не правильный тип аргумента >
  mnl_INVALID_VALUE = _6; // Не правильное значение аргумента >
  mnl_INVALID_OPERATION = _7; // Не правильная операция >
  mnl_STACK_OVERFLOW = _8; // Переполнение стека >
  mnl_OUT_OF_MEMORY = _9; // Не хватает памяти >
  mnl_NO_ERROR = _10; // Нет ошибок >
  mnl_GL_VENDOR = _11; // производитель >
  mnl_GL_RENDERER = _12; // Видеокарта >
  mnl_GL_VERSION = _13; // Версия OpenGL >
  mnl_GL_EXTENSIONS = _14; // Список расширений OpenGL >
  mnl_AL_VENDOR = _15; // Изготовитель >
  mnl_AL_VERSION = _16; // Версия OpenGL >
  mnl_AL_RENDERER = _17; // Аудиоустройство >
  mnl_AL_EXTENSIONS = _18; // Список расширений OpenAL >
  mnl_GL_INITIALIZATION = _19; // Инициализация OpenGL >
  mnl_AL_INITIALIZATION = _20; // Инициализация OpenAL >
  mnl_GL_INITIALIZATION_OK = _21; // Видеоконвеер активирован >
  mnl_AL_INITIALIZATION_OK = _22; // Аудиоконвеер активирован >
  mnl_WINDOW_CREATED = _23; // Окно создано >
  mnl_INPUT_INIT = _24; // Активация ввода >
  mnl_DRAW_LINE_INIT_START = 25; // Создание конвеера воспроизведения >
  mnl_DRAW_LINE_INIT_COMPLETE = 26; // Конвеер воспроизведения создан >
  mnl_TEXTURE_INIT_COMPLETE = 27; // Текстуры инициализированы >
  mnl_GLSL_INIT_COMPLETE = 28; // Шейдеры инициализированы >
  mnl_LIGHT_INIT_COMPLETE = 29; // Освещение инициализировано >
  mnl_FOG_INIT_COMPLETE = 30; // Туман инициализирован >
  mnl_CAMERA_INIT_COMPLETE = _31; // Камера инициализирована >
  mnl_PATCH_INIT_COMPLETE = _32; // Загружен патч >
  mnl_SOUND_LINE_INIT_START = 33; // Создание аудиоконвеера >
  mnl_SOUND_LINE_INIT_COMPLETE = 34; // Аудиоконвеер создан >
  mnl_EXPLORER_INIT_COMPLETE = 35; // Древо-путеводитель по компу >
  mnl_Extension_check = 36; // Проверка доступности расширения >
  mnl_YES = 37; // Да >
  mnl_NO = 38; // Нет >
  mnl_FreeImage_Loaded = 39; // FreeImage.dll загружена >
  mnl_BASS_Loaded = 40; // Bass.dll загружена >
  mnl_ZLib_Loaded = 41; // ZLib1.dll загружена >
  mnl_PATCH_FIN_COMPLETE = 42; // Выгружен патч >
  mnl_PATCH_INTERNET_DOWNLOAD = 43; // Из интернета загружен >
  mnl_INTERNET_DOWNLOADED = 44; // Загружено из интернэта >
  mnl_INPUT_FINALIZE = 45; // Финализация ввода >
  mnl_DRAW_FINALIZE = 46; // Финализация видео конвеера >
  mnl_OPENGL_FINALIZE = 47; // Финализация OpenGL >
  mnl_CAMERA_FINALIZE = 48; // Финализация камер >
  mnl_OPENAL_FINALIZE = 49; // Финализация OpenAL >
  mnl_SOUND_FINALIZE = 50; // Финализация звука >
  mnl_NODE_FINALIZATION = 51; // Уничтожение узлов >
  mnl_AVICAP_INITIALIZE = 52; // Загрузка AVICAP32.DLL >
  mnl_SKIP_3 = 53; //   -=> >
  mnl_SKIP_5 = 54; //     -=> >
//=============================================================================>
//=========================== Функциональность модуля =========================>
//=============================================================================>

//=============================================================================>
//============================= Глобальные переменные =========================>
//=============================================================================>
var
  mIntegerSize: Integer = cIntegerSize;
//=============================================================================>
//============================= Раздел реализации =============================>
//=============================================================================>
implementation
  // Эта процедура строит древовидную структуру файлов и каталогов по указанному адресу >
procedure FindFilesIn(Path: String; Node: TMyExNo); overload;
var p1:PSearchRec; SR:TSearchRec; v1:TMyFolderNode; v2:TMyFileNode;
begin
p1:=@SR;
SR.ExcludeAttr:=faUsual;
SR.FindHandle:=FindFirstFile(PChar(SlashSep(Path,mnSearchMask)),SR.FindData);
if (SR.FindHandle <> INVALID_HANDLE_VALUE) and (FindMatchingFile(p1) = Zero) then begin
if SR.Name <> mnDirIn then
if SR.Name <> mnDirNameUp then
if (SR.Attr and FILE_ATTRIBUTE_DIRECTORY) > Zero then begin
Sleep(10);
v1:=TMyFolderNode.Create; // Какталог\дирректория\промежуточный узел >
v1.Name:=SR.Name;
v1.Path:=SlashSep(Path,SR.Name);
Node.Add(v1); end else begin
Sleep(10);
v2:=TMyFileNode.Create; // Создаём новый узел >
v2.Name:=SR.Name;
v2.Path:=SlashSep(Path,SR.Name);
Node.Add(v2); end;
while FindNextFile(SR.FindHandle,SR.FindData) and (Zero = FindMatchingFile(p1)) do
if SR.Name <> mnDirIn then
if SR.Name <> mnDirNameUp then
if (SR.Attr and FILE_ATTRIBUTE_DIRECTORY) > Zero then begin
Sleep(10);
v1:=TMyFolderNode.Create; // Какталог\дирректория\промежуточный узел >
v1.Name:=SR.Name;
v1.Path:=SlashSep(Path,SR.Name);
Node.Add(v1); end else begin
Sleep(10);
v2:=TMyFileNode.Create; // Создаём новый узел >
v2.Name:=SR.Name;
v2.Path:=SlashSep(Path,SR.Name);
Node.Add(v2); end;
FindClose(SR.FindHandle); end else
FindClose(SR.FindHandle);
end;
//=============================================================================>
//================================== TMyParent ================================>
//=============================================================================>
constructor TMyParent.Create(Value: Pointer = nil);
begin // Конструктор >
pClrVar:=Value; // Указать, что нужно за собой очистить >
MyType:=Zero;
pProperties:=nil;
Name:=EmptyString;
end;
  // Деструктор >
destructor TMyParent.Destroy;
begin
if Assigned(pClrVar) then
Pointer(pClrVar^):=nil;
end;
//=============================================================================>
//=================================== TMyThread ===============================>
//=============================================================================>
function MyThreadEntry(var Value: TMyThread): Cardinal; stdcall;
begin // Процедура, передаваимая в винду, обеспечивающая возможность создания множества классов-потоков >
if Value = nil then
Result:=Zero else
Result:=Value.OnTreadProcLine;
end;
  // Конструктор >
constructor TMyThread.Create;
begin
inherited Create;
mStop:=true;
CreateThread(nil,Zero,@MyThreadEntry,Self,Zero,mThreadID);
end;
  // Деструктор >
destructor TMyThread.Destroy;
begin
inherited Destroy;
end;
  // Узнать приоритет >
function TMyThread.GetPriority: Integer;
begin
Result:=GetThreadPriority(mThreadID);
end;
  // То, что будет выполняться в потоке >
function TMyThread.OnTreadProcLine: Cardinal;
begin
//while mStop do begin
sleep(100);
beep(200,100); //end;
Result:=Zero;
end;
  // Установить приоритет >
procedure TMyThread.SetPriority(Value: Integer);
begin
SetThreadPriority(mThreadID,Value);
end;
//=============================================================================>
//=================================== TMyNode =================================>
//=============================================================================>
constructor TMyNode.Create;
begin // Конструктор >
inherited Create;
SetLength(mItems,Zero);
mHigh:=mOne;
mCap:=Zero;
mParent:=nil;
mNumber:=mOne;
mCount:=Zero;
mContainerType:=Zero;
end;
  // Деструктор >
destructor TMyNode.Destroy;
begin
if Assigned(mParent) then
mParent.Remove(mNumber);
Clear;
inherited Destroy;
end;
  // Уничтожиться вместе совсем, что подключено (рекурсия) >
destructor TMyNode.DestroyAll;
begin
if Assigned(mParent) then
mParent.Remove(mNumber);
ClearDestroyAll;
if Assigned(pClrVar) then
Pointer(pClrVar^):=nil;
end;
  // Установить ёмкость списка >
function TMyNode.SetCount(Value: Cardinal): Boolean;
var a1:Cardinal;
begin
if Value = Count then
Result:=true else begin
a1:=_256*(One+(Value div _256));
if a1 <> mCap then begin
SetLength(mItems,a1);
mCap:=a1; end;
mCount:=Value;
mHigh:=Value-One;
result:=true; end;
end;
  // Удалить без уничтожения все узлы только своего списка >
function TMyNode.Clear: Boolean;
var a1:Cardinal;
begin
if Count = Zero then
Result:=true else begin
for a1:=Zero to mHigh do begin
mItems[a1].mParent:=nil;
mItems[a1].mNumber:=mOne; end;
Result:=SetCount(Zero); end;
end;
  // Снести все узлы только в своём списке >
function TMyNode.ClearDestroy: Boolean;
var a1:Cardinal;
begin
if Count = Zero then
Result:=true else begin
for a1:=Zero to mHigh do begin
mItems[a1].mParent:=nil;
mItems[a1].mNumber:=mOne;
mItems[a1].Destroy; end;
Result:=SetCount(Zero); end;
end;
  // Снести все подключённые узлы (рекурсия) >
function TMyNode.ClearDestroyAll: Boolean;
var a1:Cardinal;
begin
if Count = Zero then
Result:=true else begin
for a1:=Zero to mHigh do begin
mItems[a1].mParent:=nil;
mItems[a1].mNumber:=mOne;
mItems[a1].ClearDestroyAll;
mItems[a1].Destroy; end;
Result:=SetCount(Zero); end;
end;
  // Посчитать все узлы подключнные к этому >
function TMyNode.GetCountAll: Cardinal;
var a1:Cardinal;
begin
Result:=Count;
if Result > Zero then
for a1:=Zero to mHigh do
Inc(Result,mItems[a1].GetCountAll);
end;
  // Получить элемент с таким-то индексом >
function TMyNode.GetItem(Index: Cardinal): TMyNode;
begin
if Index < Count then
Result:=mItems[Index] else
Result:=nil;
end;
  // Удалить элемент с таким-то индексом >
function TMyNode.Remove(Index: Cardinal): Boolean;
begin
if Index < Count then begin
mItems[Index].mParent:=nil;
mItems[Index].mNumber:=mOne;
if Integer(Index) < mHigh then begin
mItems[Index]:=mItems[mHigh];
mItems[Index].mNumber:=Index; end;
Result:=SetCount(mHigh); end else
Result:=false;
end;
  // Созать пустой элемент в списке >
function TMyNode.Add: TMyNode;
begin
if SetCount(Count+One) then begin
Result:=TMyNode.Create;
mItems[mHigh]:=Result;
Result.mParent:=Self;
Result.mNumber:=mHigh; end else
Result:=nil;
end;
  // Добавить элемент >
function TMyNode.Add(Value: TMyNode): Boolean;
begin
if Value = nil then
Result:=false else
if Value.mParent = nil then
if SetCount(Count+One) then begin
mItems[mHigh]:=Value;
Value.mParent:=Self;
Value.mNumber:=mHigh;
Result:=true; end else
Result:=false else
if Value.mParent.Remove(Value.mNumber) then
if SetCount(Count+One) then begin
mItems[mHigh]:=Value;
Value.mParent:=Self;
Value.mNumber:=mHigh;
Result:=true; end else
Result:=false else
Result:=false;
end;
  // Сжать список, выбросив из массива пустые элементы >
procedure TMyNode.Compress;
var a1:Cardinal;
begin
if Count > Zero then
for a1:=Zero to mHigh do
mItems[a1].Compress;
if mCap <> Count then begin
SetLength(mItems,Count);
mCap:=Count; end;
end;
  // Получить первый елемент из списка >
function TMyNode.GetFirst: TMyNode;
begin
if Count > Zero then
Result:=mItems[Zero] else
Result:=nil;
end;
  // Получить последний елемент из списка >
function TMyNode.GetLast: TMyNode;
begin
if Count > Zero then
Result:=mItems[mHigh] else
Result:=nil;
end;
  // Указатель на указатель на контэйнер >
function TMyNode.GetPreContainer: Pointer;
begin
Result:=@pContainer;
end;
//=============================================================================>
//=================================== TMyItem =================================>
//=============================================================================>
constructor TMyItem.Create;
begin // Конструктор >
inherited Create;
UpDateViewTime;
with mIPack do begin
mCreate:=mView;
mEdit:=mView;
pCreate:=@mCreate;
pView:=@mView;
pEdit:=@mEdit; end;
pIPack:=@mIPack;
end;
  // Деструктор >
destructor TMyItem.Destroy;
begin
inherited Destroy;
end;
  // Обновить время последнего обзора >
procedure TMyItem.UpDateEditTime;
var v1:TSystemTime;
begin
GetSystemTime(v1);
with mIPack.mEdit do begin
wYear:=v1.wYear;
bMonth:=v1.wMonth;
bDay:=v1.wDay;
bHour:=v1.wHour;
bMinute:=v1.wMinute;
bSecond:=v1.wSecond; end;
end;
  // Обновить время последнего обзора >
procedure TMyItem.UpDateViewTime;
var v1:TSystemTime;
begin
GetSystemTime(v1);
with mIPack.mView do begin
wYear:=v1.wYear;
bMonth:=v1.wMonth;
bDay:=v1.wDay;
bHour:=v1.wHour;
bMinute:=v1.wMinute;
bSecond:=v1.wSecond; end;
end;
//=============================================================================>
//=================================== TMyExNo =================================>
//=============================================================================>
constructor TMyExNo.Create;
begin // Конструктор >
inherited Create;
mPath:=EmptyString;
MyType:=mnExNo;
end;
  // Деструктор >
destructor TMyExNo.Destroy;
begin
inherited Destroy;
end;
  // Установить "путь" >
procedure TMyExNo.SetPath(Value: String);
begin
mPath:=Value;
pPath:=PChar(Value);
end;
//=============================================================================>
//================================ TMyFileNode ================================>
//=============================================================================>
function TMyFileNode.CopyTo(Value: TMyFolderNode; OverWrite: Boolean): Boolean;
var v1:TMyFileNode;
begin
if Assigned(Value) then
if CopyFile(pPath,PChar(SlashSep(Value.mPath,Name)),not OverWrite) then begin
v1:=TMyFileNode.Create;
v1.Name:=Name;
Result:=Value.Add(v1); end else
Result:=false else
Result:=false;
end;
  // Копировать туда-то >
function TMyFileNode.CopyTo(Value: TMyDriveNode; OverWrite: Boolean): Boolean;
var v1:TMyFileNode;
begin
if Assigned(Value) then
if CopyFile(pPath,PChar(SlashSep(Value.mPath,Name)),not OverWrite) then begin
v1:=TMyFileNode.Create;
v1.Name:=Name;
Result:=Value.Add(v1); end else
Result:=false else
REsult:=false;
end;
  // Конструктор >
constructor TMyFileNode.Create;
begin
inherited Create;
MyType:=mnFile;
Properties:=@mParams;
end;
  // Удалить (Деструктор) >
destructor TMyFileNode.Delete;
begin
if DeleteFile(pPath) then
inherited Destroy else
Exit;
end;
  // Деструктор >
destructor TMyFileNode.Destroy;
begin
inherited Destroy;
end;
  // Свойства связанного файла >
function TMyFileNode.UpDate: Boolean;
var a1:Cardinal; a2:Integer; a3:TWin32FindData; a4:TFileTime;
begin
FillChar(Result,cFileLinkParamsSize,Zero);
a1:=FindFirstFile(pPath,a3);
if a1 <> INVALID_HANDLE_VALUE then begin
FindClose(a1);
FileTimeToLocalFileTime(a3.ftLastWriteTime,a4);
if FileTimeToDosDateTime(a4,TLPack(a2).Hi,TLPack(a2).Lo) then
if a2 <> - One then
with mParams do begin
mSize:=a3.nFileSizeLow; end; end;
end;
  // "Обновка" >
function TMyFileNode.UpDateAll: Boolean;
begin
Result:=UpDate;
end;
  // Выполнить связанный файл средствами WIndows >
function TMyFileNode.Execute: Boolean;
begin
Result:=false;
end;
  // Проверка ликвидности >
function TMyFileNode.Exists: Boolean;
begin
Result:=FileExists(pPath);
end;
//=============================================================================>
//================================ TMyFolderNode ==============================>
//=============================================================================>
constructor TMyFolderNode.Create;
begin // Конструктор >
inherited Create;
MyType:=mnFolder;
Properties:=@mParams;
end;
  // Деструктор >
destructor TMyFolderNode.Destroy;
begin
inherited Destroy;
end;
  // Деструктор с удалением связанного каталога >
destructor TMyFolderNode.Delete;
var a1:Cardinal; v1:TMyExNo;
begin
if Count > Zero then
for a1:=Zero to Max do begin
v1:=TMyExNo(Items[a1]);
if Assigned(v1) then
if v1.MyType = mnFile then
TMyFileNode(v1).Delete else
if v1.MyType = mnFolder then
TMyFolderNode(v1).Delete else
Exit; end;
if RemoveDirectory(pPath) then
inherited Destroy else begin
Exit; end;
end;
  // Обновить >
function TMyFolderNode.UpDate: Boolean;
var a1:Cardinal; a2:Integer; a3:TWin32FindData; a4:TFileTime;
begin
FillChar(mParams,cFileLinkParamsSize,Zero);
a1:=FindFirstFile(PChar(Path),a3);
if a1 = INVALID_HANDLE_VALUE then
Result:=false else begin
FindClose(a1);
FileTimeToLocalFileTime(a3.ftLastWriteTime,a4);
if FileTimeToDosDateTime(a4,TLPack(a2).Hi,TLPack(a2).Lo) then
if a2 <> - One then
with mParams do begin
if ClearDestroyAll then
FindFilesIn(Path,Self);
mSize:=a3.nFileSizeLow;
Result:=true; end else
Result:=false else
Result:=false; end;
end;
  // Полнопроходное обновление >
function TMyFolderNode.UpDateAll: Boolean;
var a1:Cardinal;
begin
if UpDate then begin
Result:=true;
if Count > Zero then
for a1:=Zero to Max do
if Items[a1].MyType = mnFolder then
if not TMyFolderNode(Items[a1]).UpDateAll then begin
Result:=false;
Break; end; end else
Result:=false;
end;
  // Копировать в такой-то диск >
function TMyFolderNode.CopyTo(Value: TMyDriveNode; OverWrite: Boolean): Boolean;
begin
Result:=false;
end;
  // Копировать в такой-то каталог >
function TMyFolderNode.CopyTo(Value: TMyFolderNode; OverWrite: Boolean): Boolean;
begin
Result:=false;
end;
  // Создать каталог >
function TMyFolderNode.CreateFolder(Value: String): TMyFolderNode;
var v1:TMyFolderNode;
begin
if CreateDirectory(PChar(SlashSep(mPath,Value)),nil) then begin
v1:=TMyFolderNode.Create;
Add(v1);
v1.Name:=Value; end else begin
RemoveDirectory(PChar(SlashSep(mPath,Value)));
v1:=nil; end;
Result:=v1;
end;
  // Свойства >
function TMyFolderNode.Exists: Boolean;
begin
Result:=FileExists(pPath);
end;
//=============================================================================>
//================================ TMyDriveNode ===============================>
//=============================================================================>
constructor TMyDriveNode.Create(DriveChar: Char);
begin // Конструктор >
inherited Create;
MyType:=mnDrive;
Properties:=@mDrivePack;
FillWithZero(Properties,cDriveParamsSize);
mDriveChar:=DriveChar;
Path:=DriveChar+mnDriveApp;
Name:=Path;
UpDate;
end;
  // Деструктор >
destructor TMyDriveNode.Destroy;
begin
inherited Destroy;
end;
  // Обновить данные о диске\приводе\устройстве\разделе\... >
function TMyDriveNode.UpDate: Boolean;
var MaxComponentLength:Cardinal; mName,mFileSystem:TMySystemPath;
begin
with mDrivePack,Additional do
if GetVolumeInformation(pPath,@mName,MAX_PATH,@SerialNumber,MaxComponentLength,FileSystemFlags,@mFileSystem,MAX_PATH) then begin
FileSystem:=String(mFileSystem);
GetDiskFreeSpace(pPath,SectorsPerCluster,BytesPerSector,NumberOfFreeClusters,TotalNumberOfClusters);
GetDiskFreeSpaceEx(pPath,FreeSize,FullSize,nil);
DriveType:=GetDriveType(pPath);
Name:=mName;
if ClearDestroyAll then
FindFilesIn(pPath,Self);
Result:=true; end else
Result:=false;
end;
  // Обновиться полностью >
function TMyDriveNode.UpDateAll: Boolean;
var a1:Cardinal;
begin
if UpDate then begin
Result:=true;
if Count > Zero then
for a1:=Zero to Max do
if Items[a1].MyType = mnFolder then
if not TMyFolderNode(Items[a1]).UpDateAll then begin
Result:=false;
Break; end; end else
Result:=false;
end;
  // Создать папку >
function TMyDriveNode.CreateFolder(Value: String): TMyFolderNode;
var v1:TMyFolderNode;
begin
if CreateDirectory(PChar(SlashSep(mPath,Value)),nil) then try
v1:=TMyFolderNode.Create;
v1.Name:=Value;
Add(v1);
Result:=v1; except
Result:=nil; end else
Result:=nil;
end;
  // Проверка ликвидности >
function TMyDriveNode.GetLinkCheck: Boolean;
var a1,mSerialNumber,MaxComponentLength,mFileSystemFlags:Cardinal;
mName,mFileSystem:TMySystemPath; a2:TMyDrivesSet;
begin
Result:=false;
Cardinal(a2):=GetLogicalDrives;
for a1:=Zero to mnMaxDrive do
if a1 in a2 then
if Char(Ord(mnFirstDriveChar)+a1) = mDriveChar then
if GetVolumeInformation(pPath,@mName,MAX_PATH,@mSerialNumber,MaxComponentLength,mFileSystemFlags,@mFileSystem,MAX_PATH) then begin
if mDrivePack.Additional.SerialNumber = mSerialNumber then begin
Result:=true;
Break; end else
Break; end;
end;
//=============================================================================>
//================================= TMyDrivesNode =============================>
//=============================================================================>
constructor TMyDrivesNode.Create;
begin // Конструктор >
inherited Create;
MyType:=mnDrives;
UpDate;
end;
  // Деструктор >
destructor TMyDrivesNode.Destroy;
begin
inherited Destroy;
end;
  // Обновить список >
function TMyDrivesNode.UpDate: Boolean;
var a1:Cardinal; a2:TMyDrivesSet;
begin
if ClearDestroyAll then begin
Cardinal(a2):=GetLogicalDrives;
for a1:=Zero to mnMaxDrive do
if a1 in a2 then
Add(TMyDriveNode.Create(Char(Ord(mnFirstDriveChar)+a1)));
Result:=Count > Zero; end else
Result:=false;
end;
  // Обновиться полностью >
function TMyDrivesNode.UpDateAll: Boolean;
var a1:Cardinal;
begin
if UpDate then begin
Result:=true;
if Count > Zero then
for a1:=Zero to Max do
if not TMyDriveNode(Items[a1]).UpDateAll then begin
Result:=false;
Break; end; end else
Result:=false;
end;
//=============================================================================>
//================================== TMyOSMSWindows ===========================>
//=============================================================================>
constructor TMyOSMSWindowsNode.Create;
begin // Конструктор >
inherited Create;
MyType:=mnWindows;
Properties:=@mWindowsPack;
UpDate;
end;
  // Деструктор >
destructor TMyOSMSWindowsNode.Destroy;
begin
inherited Destroy;
end;
  // Обновить настройки >
procedure TMyOSMSWindowsNode.UpDate;
var v1:TOSVersionInfo; mBuff:TMySystemPath;
begin
v1.dwOSVersionInfoSize:=SizeOf(v1);
if GetVersionEx(v1) then
with mWindowsPack do begin
CSDVersion:=String(v1.szCSDVersion);
Build:=v1.dwBuildNumber;
with Additional do begin
MajorVersion:=v1.dwMajorVersion;
MinorVersion:=v1.dwMinorVersion;
PlatformId:=v1.dwPlatformId;
GetSystemDirectory(@mBuff,MAX_PATH);
NucleusPath:=String(mBuff);
Path:=ExtractFilePath(NucleusPath); end; end;
end;
//=============================================================================>
//================================ TMyRAMNode =================================>
//=============================================================================>
constructor TMyRAMNode.Create;
begin // Конструктор >
inherited Create;
MyType:=mnRAMClass;
Properties:=@mRamPack;
end;
  // Деструктор >
destructor TMyRAMNode.Destroy;
begin
inherited Destroy;
end;
  // Обновить сведения об оперативной памяти >
function TMyRAMNode.UpDate: Boolean;
var v1:TMemoryStatus;
begin
GlobalMemoryStatus(v1);
with mRamPack do begin
with mPhisical do begin
FullMemory:=v1.dwTotalPhys;
FreeMemory:=v1.dwAvailPhys;
UsedMemory:=FullMemory-FreeMemory; end;
with mVirtual do begin
FreeMemory:=v1.dwAvailVirtual;
FullMemory:=v1.dwTotalVirtual;
UsedMemory:=FullMemory-FreeMemory; end;
with mPageFile do begin
FreeMemory:=v1.dwAvailPageFile;
FullMemory:=v1.dwTotalPageFile;
UsedMemory:=FullMemory-FreeMemory; end;
Result:=true; end;
end;
//=============================================================================>
//=============================== TMyComputerNode =============================>
//=============================================================================>
constructor TMyComputerNode.Create;
begin // Конструктор >
inherited Create;
MyType:=mnComputer;
UpDate;
end;
  // Деструктор >
destructor TMyComputerNode.Destroy;
begin
inherited Destroy;
end;
  // Обновить данные >
function TMyComputerNode.UpDate: Boolean;
var TimerHi,TimerLo:Cardinal; PriorityClass,Priority:Integer;
begin
PriorityClass:=GetPriorityClass(GetCurrentProcess);
Priority:=GetThreadPriority(GetCurrentThread);
SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS);
SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_TIME_CRITICAL);
Sleep(Ten);
asm
dw 310Fh
mov TimerLo, eax
mov TimerHi, edx
end;
Sleep(mCPUDT);
asm
dw 310Fh
sub eax, TimerLo
sbb edx, TimerHi
mov TimerLo, eax
mov TimerHi, edx
end;
SetThreadPriority(GetCurrentThread,Priority);
SetPriorityClass(GetCurrentProcess,PriorityClass);
mCPUSpeed:=TimerLo/(1000.0*mCPUDT);
Result:=mCPUSpeed > Zero;
end;
  // Обновить все данные... >
function TMyComputerNode.UpDateAll: Boolean;
begin
Result:=UpDate;
end;
  // Эта процедура строит "образ" по указанному адресу >
procedure FindFilesIn(Path: String; Node: TMyNode); overload;
var a1:Cardinal; v3:TWin32FindData; v1:TMyFolderImage; v2:TMyFileImage;
begin
a1:=FindFirstFile(PChar(SlashSep(Path,mnSearchMask)),v3);
if a1 <> INVALID_HANDLE_VALUE then begin 
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then begin // Какталог >
Sleep(10);
v1:=TMyFolderImage.Create;
v1.Name:=v3.cFileName;
Node.Add(v1);
FindFilesIn(SlashSep(Path,v3.cFileName),v1); end else begin // Файл >
Sleep(10);
v2:=TMyFileImage.Create;
v2.Name:=v3.cFileName;
v2.mPack.mSize:=v3.nFileSizeHigh or v3.nFileSizeLow shl _32;
v2.mPack.mCreateTime:=v3.ftCreationTime;
v2.mPack.mViewTime:=v3.ftLastAccessTime;
v2.mPack.mEditTime:=v3.ftLastWriteTime;
v2.mPack.mFileType:=GetFileType(a1);
Node.Add(v2); end;
while FindNextFile(a1,v3) do
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then begin // Какталог >
Sleep(10);
v1:=TMyFolderImage.Create;
v1.Name:=v3.cFileName;
Node.Add(v1);
FindFilesIn(SlashSep(Path,v3.cFileName),v1); end else begin // Файл >
Sleep(10);
v2:=TMyFileImage.Create;
v2.Name:=v3.cFileName;
v2.mPack.mSize:=v3.nFileSizeHigh or v3.nFileSizeLow shl _32;
v2.mPack.mCreateTime:=v3.ftCreationTime;
v2.mPack.mViewTime:=v3.ftLastAccessTime;
v2.mPack.mEditTime:=v3.ftLastWriteTime;
v2.mPack.mFileType:=GetFileType(a1);
Node.Add(v2); end;
FindClose(a1); end else
FindClose(a1);
end;
//=============================================================================>
//================================= TMyImageNode ==============================>
//=============================================================================>
function TMyImageNode.GetFullPath: String;
var v1:TMyNode;
begin // Возвращает разделённые слэшем строкой все имена родительских узлов и своё >
v1:=Self;
Result:=Name;
if Assigned(Parent) then repeat
v1:=v1.Parent;
Result:=SlashSep(v1.Name,Result); until
Assigned(v1);
end;
//=============================================================================>
//================================= TMyFileImage ==============================>
//=============================================================================>
constructor TMyFileImage.Create;
begin // Конструктор >
inherited Create;
MyType:=mnFileImage;
end;
  // Деструктор >
destructor TMyFileImage.Destroy;
begin
inherited Destroy;
end;
  // Время создания >
function TMyFileImage.GetCreateTime: TSystemTime;
begin
FileTimeToSystemTime(mPack.mCreateTime,Result);
end;
  // Время последнего изменения >
function TMyFileImage.GetEditTime: TSystemTime;
begin
FileTimeToSystemTime(mPack.mEditTime,Result);
end;
  // Время последнего просмотра >
function TMyFileImage.GetViewTime: TSystemTime;
begin
FileTimeToSystemTime(mPack.mViewTime,Result);
end;
  // Расширение этого файла >
function TMyFileImage.GetExtension: String;
begin
Result:=ExtractFileExt(Name);
end;
  // Проверяет существует-ли такой адрес файла на компе >
function TMyFileImage.GetExists: Boolean;
begin
Result:=FileExists(Path);
end;
  // Записываемся на диск >
procedure TMyFileImage.WriteMe;
begin
mFS.WriteCardinal(MyType);
mFS.Write(Name);
mFS.Write(mPack,SizeOF(mPack));
end;
  // Читаем себя с диска >
procedure TMyFileImage.ReadMe;
begin
Name:=mFS.ReadString;
mFS.Read(mPack,SizeOF(mPack));
end;
//=============================================================================>
//================================ TMyFolderImage =============================>
//=============================================================================>
constructor TMyFolderImage.Create;
begin // Конструктор >
inherited Create;
MyType:=mnFolderImage;
end;
  // Деструктор >
destructor TMyFolderImage.Destroy;
begin
inherited Destroy;
end;
  // Размер всего, что есть к данном каталоге >
function TMyFolderImage.GetSize: Int64;
var a1:Cardinal;
begin
Result:=Zero;
if Count > Zero then
for a1:=Zero to Max do
case Items[a1].MyType of
mnFileImage: Inc(Result,TMyFileImage(Items[a1]).Size);
mnFolderImage: Inc(Result,TMyFolderImage(Items[a1]).Size); end;
end;
  // Проверяет существует-ли такой адрес каталога на компе >
function TMyFolderImage.GetExists: Boolean;
begin
Result:=FileExists(Path);
end;
  // Запись на диск >
procedure TMyFolderImage.WriteMe;
var a1:Cardinal;
begin
mFS.WriteCardinal(MyType);
mFS.Write(Name);
mFS.WriteCardinal(Count);
if Count > Zero then
for a1:=Zero to Max do begin
TMyImageNode(Items[a1]).mFS:=mFS;
if Items[a1].MyType = mnFileImage then
TMyFileImage(Items[a1]).WriteMe else
TMyFolderImage(Items[a1]).WriteMe; end;
end;
  // Чтение с диска >
procedure TMyFolderImage.ReadMe;
var a1,a2:Cardinal; v1:TMyFileImage; v2:TMyFolderImage;
begin
Name:=mFS.ReadString;
mFS.Read(a2);
if a2 > Zero then
for a1:=One to a2 do
if mFS.ReadCardinal = mnFileImage then begin
v1:=TMyFileImage.Create;
v1.mFS:=mFS;
v1.ReadMe;
Add(v1); end else begin
v2:=TMyFolderImage.Create;
v2.mFS:=mFS;
v2.ReadMe;
Add(v2); end;
end;
//=============================================================================>
//================================= TMyDiskImage ==============================>
//=============================================================================>
constructor TMyDiskImage.Create(CharName: String);
var MaxComponentLength:Cardinal; sName,sFileSystem:TMySystemPath;
begin // Конструктор >
inherited Create;
MyType:=mnDiskImage;
Name:=UpperCase(CharName)+mnTwoDots+mnSlash;
with mPack do begin
if GetVolumeInformation(PChar(Name),@sName,MAX_PATH,@SerialNumber,MaxComponentLength,mFileSystemFlags,@sFileSystem,MAX_PATH) then begin
mFileSystem:=String(sFileSystem);
mLabel:=sName; end;
GetDiskFreeSpace(PChar(Name),mSectorsPerCluster,mBytesPerSector,mNumberOfFreeClusters,mTotalNumberOfClusters);
if GetDiskFreeSpaceEx(PChar(Name),mFreeSize,mFullSize,nil) then 
mUsedSize:=mFullSize-mFreeSize;
mDriveType:=GetDriveType(PChar(Name)); end;
FindFilesIn(Name,Self); // Сделать образ укзанного диска >
end;
  // Деструктор >
destructor TMyDiskImage.Destroy;
begin
inherited Destroy;
end;
  // Записать на диск >
function TMyDiskImage.SaveToFile(Path: String): Boolean;
begin
mFS:=TMyFileStream.Create;
if mFS.CreateWrite(PChar(Path)) then begin
mFS.Write(mPack,SizeOf(mPack));
mFS.Write(mCoverName);
mFS.Write(mFileSystem);
mFS.Write(mLabel);
mFS.Write(mOwner);
mFS.Write(mHolder);
WriteMe;
Result:=true; end else
Result:=false;
mFS.Destroy;
end;
  // Загрузить с диска >
function TMyDiskImage.LoadFromFile(Path: String): Boolean;
begin
mFS:=TMyFileStream.Create;
if mFS.OpenRead(PChar(Path)) then begin
mFS.Read(mPack,SizeOf(mPack));
mFS.Read(mCoverName);
mFS.Read(mFileSystem);
mFS.Read(mLabel);
mFS.Read(mOwner);
mFS.Read(mHolder);
mFS.ReadCardinal;
ReadMe;
Result:=true; end else
Result:=false;
mFS.Destroy;
end;
//=============================================================================>
//============================== TMyStringList ================================>
//=============================================================================>
constructor TMyStringList.Create;
var a1:Cardinal;
begin // Конструктор >
inherited Create;
for a1:=Zero to ByteMax do begin
mCharCodes[a1]:=false;
mDividorCodes[a1]:=true; end; 
MakeCharCodes(One,mnRusDefCharCodesLo,false);
MakeCharCodes(One,mnRusDefCharCodesHi,false);
MakeCharCodes(One,mnEngDefCharCodesLo,false);
MakeCharCodes(One,mnEngDefCharCodesHi,false);
MakeCharCodes(Zero,mnRusDefCharCodesLo,true);
MakeCharCodes(Zero,mnRusDefCharCodesHi,true);
MakeCharCodes(Zero,mnEngDefCharCodesLo,true);
MakeCharCodes(Zero,mnEngDefCharCodesHi,true);
SetLength(mStrings,Zero);
mStringsCount:=Zero;
mStringsHigh:=mOne;
mStringsCap:=Zero;
mStringsCrnt:=mOne;
end;
  // Деструктор >
destructor TMyStringList.Destroy;
begin
inherited Destroy;
end;
  // Добавить список строк >
function TMyStringList.Add(const Value: TMyStringList): Boolean;
var a1:Cardinal;
begin
if Assigned(Value) then
if Value.mStringsCount = Zero then
Result:=false else
if SetStrCount(mStringsCount+Value.mStringsCount) then begin
for a1:=One to Value.mStringsCount do
mStrings[mStringsCount-a1]:=Value.mStrings[a1-One];
Result:=true; end else
Result:=false else
Result:=false;
end;
  // Добавить одну строку >
function TMyStringList.Add(const Value: String): Boolean;
begin
if SetStrCount(mStringsCount+One) then begin
mStrings[mStringsHigh]:=Value;
Result:=true; end else
Result:=false;
end;
  // Поменять местами пару строк >
function TMyStringList.Exchange(Index1,Index2: Cardinal): Boolean;
var s1:String;
begin
if Index1 < mStringsCount then
if Index1 < mStringsCount then
if Index1 = Index2 then
Result:=true else begin
s1:=mStrings[Index1];
mStrings[Index1]:=mStrings[Index2];
mStrings[Index2]:=s1;
Result:=true; end else
Result:=false else
Result:=false;
end;
  // Добыть строку по номеру >
function TMyStringList.GetLine(Index: Cardinal): String;
begin
if Index < mStringsCount then
Result:=mStrings[Index] else
Result:=EmptyString;
end;
  // Номер строки в списке >
function TMyStringList.IndexOf(Value: String): Integer;
var a1:Cardinal;
begin
Result:=-One;
if Length(Value) > Zero then
if mStringsCount > Zero then
for a1:=Zero to mStringsHigh do
if Value = mStrings[a1] then begin
Result:=a1;
Break; end;
end;
  // Установить значение такой-то строки >
procedure TMyStringList.SetLine(Index: Cardinal; Value: String);
begin
if Index < mStringsCount then
mStrings[Index]:=Value;
end;
  // Установить ёмкость списка строк >
function TMyStringList.SetStrCount(Value: Cardinal): Boolean;
var a1:Cardinal;
begin
if Value = mStringsCount then
Result:=true else begin
a1:=((Value div NodeSimpleInc)+One)*NodeSimpleInc;
if a1 <> mStringsCap then begin
SetLength(mStrings,a1);
mStringsCap:=a1;end;
mStringsCount:=Value;
mStringsHigh:=Value - One;
Result:=true; end;
end;
  // Удалить >
function TMyStringList.Remove(Index: Cardinal): Boolean;
var a1:Cardinal;
begin
if Index < mStringsCount then begin
if Integer(Index) < mStringsHigh then
for a1:=Index to mStringsHigh - One do
mStrings[a1]:=mStrings[a1 + One];
Result:=SetStrCount(mStringsHigh); end else
Result:=false;
end;
  // Очистить список >
function TMyStringList.Clear: Boolean;
begin
Result:=SetStrCount(Zero);
end;
  // Загрузить из обычного текстового файла >
function TMyStringList.LoadFromTextFile(Path: PChar): Boolean;
var s1:String;
begin
if FileExists(Path) then
if Clear then
if OpenRead(Path) then begin
while ReadLn(s1) do
if SetStrCount(mStringsCount+One) then
mStrings[mStringsHigh]:=s1 else
Break;
Close;
Result:=true; end else
Result:=false else
Result:=false else
Result:=false;
end;
  // Сохранить в текстовый файл >
function TMyStringList.SaveToTextFile(Path: PChar): Boolean;
var a1:Cardinal;
begin
if OpenWrite(Path) then begin
Result:=true;
if mStringsCount > Zero then
for a1:=Zero to mStringsHigh do
if not WriteLn(mStrings[a1]) then begin
Result:=false;
Break; end;
ResizeBuffer(Zero);
Close; end else
Result:=false;
end;
  // Пометить указанные в строке символы "буквенными" кодами или наоборот >
function TMyStringList.MakeCharCodes(mType: Cardinal; Line: String; Value: Boolean): Boolean;
var a1,a2:Cardinal;
begin
a2:=Length(Line);
if a2 = Zero then
Result:=false else
case mType of
Zero: begin
for a1:=One to a2 do
mCharCodes[Byte(Line[a1])]:=Value;
Result:=true; end;
One: begin
for a1:=One to a2 do
mDividorCodes[Byte(Line[a1])]:=Value;
Result:=true; end;
else Result:=false; end;
end;
  // Разобрать текстовый файл на отдельные слова >
function TMyStringList.StripTextFileToWords(Path: PChar): Boolean;
var a1,a2:Cardinal; s1,s2:String;
begin
Clear;
if OpenRead(Path) then begin
while ReadLn(s2) do begin
a2:=Length(s2);
if a2 > Zero then begin
s1:=EmptyString;
for a1:=One to a2 do
if mDividorCodes[Byte(s2[a1])] then begin
if Length(s1) > Zero then begin
Add(s1);
s1:=EmptyString; end; end else
s1:=s1+s2[a1];
if Length(s1) > Zero then
Add(s1); end; end;
Close; end;
Result:=Count > Zero;
end;
  // Разобрать строку наслова >
function TMyStringList.StripStringToWords(const Value: String): Boolean;
var a1,a2:Cardinal; s1:String;
begin
Clear;
a2:=Length(Value);
if a2 > Zero then begin
s1:=EmptyString;
for a1:=One to a2 do
if (Value[a1] = mDivOfCom) or (Byte(Value[a1]) = mEndLine) or (Byte(Value[a1]) = mnBreakLine) then begin
if Length(s1) > Zero then begin
Add(s1);
s1:=EmptyString; end; end else
s1:=s1+Value[a1];
if Length(s1) > Zero then
Add(s1); end;
Result:=Count > Zero;
end;
  // Пропустить строчки >
procedure TMyStringList.Skip(Value: Cardinal = One);
begin
Inc(mStringsCrnt,Value);
if mStringsCrnt > mStringsHigh then
if mStringsCount = Zero then
mStringsCrnt:=mStringsHigh else
mStringsCrnt:=Zero;
end;
  // Получить первую строчку >
function TMyStringList.GetFirst: String;
begin
if mStringsCount = Zero then begin
mStringsCrnt:=mStringsHigh;
Result:=EmptyString; end else begin
mStringsCrnt:=Zero;
Result:=mStrings[mStringsCrnt]; end;
end;
  // Получить последнюю строчку >
function TMyStringList.GetLast: String;
begin
if mStringsCount = Zero then
Result:=EmptyString else
Result:=mStrings[mStringsHigh]; 
mStringsCrnt:=mStringsHigh;
end;
  // Получить следующую строку >
function TMyStringList.GetNext: String;
begin
if mStringsCount = Zero then
Result:=EmptyString else begin
Skip;
Result:=mStrings[mStringsCrnt]; end;
end;
  // Текущую строку >
function TMyStringList.GetThis: String;
begin
if mStringsCount = Zero then
Result:=EmptyString else
Result:=mStrings[mStringsCrnt];
end;
  // Собственно сканирование >
function TMyStringList.Scan(Caption,Path: String): Boolean;
var a1:Cardinal; v3:TWin32FindData;
begin
Clear;
a1:=FindFirstFile(PChar(SlashSep(Path,mnSearchMask)),v3);
if a1 <> INVALID_HANDLE_VALUE then begin 
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = Zero then
if Pos(UpperCase(Caption),UpperCase(v3.cFileName)) > Zero then
Add(SlashSep(Path,v3.cFileName));
while FindNextFile(a1,v3) do
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = Zero then
if Pos(UpperCase(Caption),UpperCase(v3.cFileName)) > Zero then
Add(SlashSep(Path,v3.cFileName));
FindClose(a1); end else
FindClose(a1);
Result:=Count > Zero;
end;
  // Рекурсивное сканирование >
procedure TMyStringList.ScanRecurse(Caption, Path: String);
var a1:Cardinal; v3:TWin32FindData;
begin 
a1:=FindFirstFile(PChar(SlashSep(Path,mnSearchMask)),v3);
if a1 <> INVALID_HANDLE_VALUE then begin 
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
ScanRecurse(Caption,SlashSep(Path,v3.cFileName)) else
if Pos(UpperCase(Caption),UpperCase(v3.cFileName)) > Zero then
Add(SlashSep(Path,v3.cFileName));
while FindNextFile(a1,v3) do
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
ScanRecurse(Caption,SlashSep(Path,v3.cFileName)) else
if Pos(UpperCase(Caption),UpperCase(v3.cFileName)) > Zero then
Add(SlashSep(Path,v3.cFileName));
FindClose(a1); end else
FindClose(a1);
end;
//=============================================================================>
//================================ TMyLibModule ===============================>
//=============================================================================>
constructor TMyLibModule.Create(Path: PChar);
begin // Конструктор >
inherited Create;
if LoadFromTextFile(Path) then
if Count = Zero then
mModuleHandle:=INVALID_HV else //begin // mModuleHandle:=GetModuleHandle(PChar(First)); mOverOut:=mModuleHandle <> INVALID_HV; if mModuleHandle = INVALID_HV then
mModuleHandle:=LoadLibrary(PChar(First)); //end; // Log.WriteLog(mnl_SKIP_3,First,Check);
end;
  // Деструктор >
destructor TMyLibModule.Destroy;
begin
if Check then
FreeLibrary(mModuleHandle);
inherited Destroy;
end;
  // Проверка >
function TMyLibModule.Check: Boolean;
begin
Result:=mModuleHandle <> INVALID_HV;
end;
  // Установка точки входа >
procedure TMyLibModule.SetEP(var pData: Pointer);
begin
if Check then
pData:=GetProcAddress(mModuleHandle,PChar(Next)) else
pData:=nil; // Log.WriteLog(mnl_SKIP_5,This,Assigned(pData));
end;
//=============================================================================>
//============================== TMyFileStream ================================>
//=============================================================================>
constructor TMyFileStream.Create;
var v1:TSystemInfo;
begin
inherited Create;
pBuffer:=nil;
pPreBuffer:=@pBuffer;
mBufferSize:=Zero;
mBufferUsed:=Zero;
mHandle:=INVALID_HV;
pPath:=nil;
pCrntPointer:=nil;
pBasePointer:=nil;
mMapping:=INVALID_HV;
GetSystemInfo(v1);
mSystemGranularity:=v1.dwAllocationGranularity;
end;
  // Деструктор >
destructor TMyFileStream.Destroy;
begin
UnViewMap;
CloseFull;
DestroyBuffer;
end;
  // Открыть для чтения >
function TMyFileStream.OpenRead(Path: PChar): Boolean;
begin
if CloseFull then begin
if FileExists(Path) then
mHandle:=CreateFile(Path,GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,Zero,Zero) else
mHandle:=INVALID_HANDLE_VALUE;
Result:=Check;
if Result then
pPath:=Path; end else
Result:=false;
end;
  // Открыть для записи >
function TMyFileStream.OpenWrite(Path: PChar): Boolean;
begin
if CloseFull then begin
if FileExists(Path) then
mHandle:=CreateFile(Path,GENERIC_WRITE,FILE_SHARE_WRITE,nil,OPEN_EXISTING,Zero,Zero) else
mHandle:=CreateFile(Path,GENERIC_WRITE,FILE_SHARE_WRITE,nil,CREATE_ALWAYS,Zero,Zero);
Result:=Check;
if Result then
pPath:=Path; end else
Result:=false;
end;
  // Создавать новый\очищать старый >
function TMyFileStream.CreateWrite(Path: PChar): Boolean;
begin
if CloseFull then begin
mHandle:=CreateFile(Path,GENERIC_WRITE,FILE_SHARE_WRITE,nil,CREATE_ALWAYS,Zero,Zero);
Result:=Check;
if Result then
pPath:=Path; end else
Result:=false;
end;
  // Открыть для чтения и записи >
function TMyFileStream.OpenReadWrite(Path: PChar): Boolean;
begin
if CloseFull then begin
if FileExists(Path) then
mHandle:=CreateFile(Path,GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_EXISTING,Zero,Zero) else
mHandle:=CreateFile(Path,GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ or FILE_SHARE_WRITE,nil,CREATE_ALWAYS,Zero,Zero);
Result:=Check;
if Result then
pPath:=Path; end else
Result:=false;
end;
  // Создание "объекта-отображения" >
function TMyFileStream.CreateMapping(cSize: Int64 = Zero): Boolean;
begin
if UnMap then begin
mMapping:=CreateFileMapping(mHandle,nil,PAGE_READWRITE,Cardinal(cSize shr _32),Cardinal(cSize),nil);
Result:=mMapping <> INVALID_HV; end else
Result:=false;
end;
  // Картирование "объекта-отображения" в память процесса >
function TMyFileStream.CreateView(cPosition,cCount: Int64): Boolean;
var v1:Int64;
begin
if UnView then begin
v1:=(cPosition div mSystemGranularity)*mSystemGranularity;
pBasePointer:=MapViewOfFile(mMapping,FILE_MAP_ALL_ACCESS,Cardinal(v1 shr _32),Cardinal(v1),Cardinal(cCount)+Cardinal(cPosition-v1));
if pBasePointer = nil then
Result:=false else begin
pCrntPointer:=Pointer(Cardinal(pBasePointer)+Cardinal(cPosition-v1));
Result:=true; end; end else
Result:=false;
end;
  // >
function TMyFileStream.MapView(cPosition,cCount: Int64): Boolean;
var v1:Int64;
begin
if pBasePointer <> nil then
if not UnMapViewOfFile(pBasePointer) then begin
Result:=false;
Exit; end;
if mMapping <> INVALID_HV then
if not CloseHandle(mMapping) then begin
Result:=false;
Exit; end;
mMapping:=CreateFileMapping(mHandle,nil,PAGE_READWRITE,Zero,Zero,nil);
if mMapping = INVALID_HV then begin
Result:=false;
Exit; end;
v1:=(cPosition div mSystemGranularity)*mSystemGranularity;
pBasePointer:=MapViewOfFile(mMapping,FILE_MAP_ALL_ACCESS,Cardinal(v1 shr _32),Cardinal(v1),Cardinal(cCount)+Cardinal(cPosition-v1));
if pBasePointer = nil then begin
Result:=false;
Exit; end;
pCrntPointer:=Pointer(Cardinal(pBasePointer)+Cardinal(cPosition-v1));
Result:=true; 
end;
  // Уничтожение "объекта-отображения" >
function TMyFileStream.UnMap: Boolean;
begin
if mMapping = INVALID_HV then
Result:=true else
if CloseHandle(mMapping) then begin
mMapping:=INVALID_HV;
Result:=true; end else
Result:=false
end;
  // Прекращение картирования "объекта-отображения" >
function TMyFileStream.UnView: Boolean;
begin
if pBasePointer = nil then
Result:=true else
if UnMapViewOfFile(pBasePointer) then begin
pBasePointer:=nil;
pCrntPointer:=nil;
Result:=true; end else
Result:=false;
end;
  // >
function TMyFileStream.UnViewMap: Boolean;
begin
if pBasePointer <> nil then
if UnMapViewOfFile(pBasePointer) then begin
pBasePointer:=nil;
pCrntPointer:=nil; end else begin
Result:=false;
Exit; end;
if mMapping = INVALID_HV then
Result:=true else
if CloseHandle(mMapping) then begin
mMapping:=INVALID_HV;
Result:=true; end else
Result:=false;
end;
  // Закрыть файл >
function TMyFileStream.Close: Boolean;
begin
if mHandle = INVALID_HV then
Result:=true else
if CloseHandle(mHandle) then begin
mHandle:=INVALID_HV;
Result:=true; end else
Result:=false;
end;
  // Разорвать все связи с файлом >
function TMyFileStream.CloseFull: Boolean;
begin
if UnViewMap then
Result:=Close else
Result:=false;
end;
  // Проверка валидности дескриптора файла >
function TMyFileStream.Check: Boolean;
begin
Result:=mHandle <> INVALID_HV;
end;
  // Узнать о достижении конца файла >
function TMyFileStream.EndOfFile: Boolean;
begin
Result:=GetFileSize(mHandle,nil) > SetFilePointer(mHandle,Zero,nil,FILE_CURRENT);
end;
  // Установить конец файла в текущую позицию >
function TMyFileStream.SetEndHere: Boolean;
begin
Result:=SetEndOfFile(mHandle);
end;
  // Установка размеров буффера (c сохранением содержимого) >
function TMyFileStream.ResizeBuffer(Size: Cardinal): Boolean;
var p1:Pointer;
begin // GlobalAlloc
if mBufferSize = Size then
Result:=true else
if pBuffer = nil then begin
GetMem(pBuffer,Size);
mBufferSize:=Size;
mBUfferUsed:=Zero;
Result:=true; end else begin
GetMem(p1,Size);
if mBufferSize > Size then
Move(pBuffer^,p1^,Size) else
Move(pBuffer^,p1^,mBufferSize);
FreeMem(pBuffer,mBufferSize);
pBuffer:=p1;
mBufferSize:=Size;
Result:=true; end;
end;
  // Просто перевыделение памяти >
function TMyFileStream.ReBuildBuffer(Size: Cardinal): Boolean;
begin
if mBufferSize = Size then
Result:=true else
if pBuffer = nil then begin
GetMem(pBuffer,Size);
mBufferSize:=Size;
mBUfferUsed:=Zero;
Result:=true; end else begin
FreeMem(pBuffer,mBufferSize);
GetMem(pBuffer,Size);
mBufferSize:=Size;
mBUfferUsed:=Zero;
Result:=true; end;
end;
  // Уничтожыть буффер >
function TMyFileStream.DestroyBuffer: Boolean;
begin
if pBuffer = nil then
Result:=true else begin
FreeMem(pBuffer,mBufferSize);
mBufferSize:=Zero;
mBufferUsed:=Zero;
pBuffer:=nil;
Result:=true; end;
end;
  // Расширить на столько-то + сохранение уже имеющегося содержимого буффера >
function TMyFileStream.ExpandBufferFor(Size: Cardinal): Boolean;
var p1:Pointer;
begin
if Size = Zero then
Result:=true else
if mBufferSize = Zero then begin
GetMem(pBuffer,Size);
mBufferSize:=Size;
mBufferUsed:=Zero;
Result:=true; end else begin
GetMem(p1,mBufferSize+Size);
Move(pBuffer^,p1^,mBufferSize);
FreeMem(pBuffer,mBufferSize);
pBuffer:=p1;
mBufferSize:=mBufferSize+Size;
Result:=true; end;
end;
  // Расширить до стольки то + сохранение уже имеющегося содержимого буффера >
function TMyFileStream.ExpandBufferUntil(Size: Cardinal): Boolean;
var p1:Pointer;
begin
if Size = Zero then
Result:=true else
if mBufferSize = Zero then begin
GetMem(pBuffer,Size);
mBufferSize:=Size;
mBufferUsed:=Zero;
Result:=true; end else
if mBufferSize >= Size then
Result:=true else begin
GetMem(p1,mBufferSize+Size);
Move(pBuffer^,p1^,mBufferSize);
FreeMem(pBuffer,mBufferSize);
pBuffer:=p1;
mBufferSize:=mBufferSize+Size;
Result:=true; end;
end;
  // Интерпретировать содержимое как набор символов "строки" >
function TMyFileStream.GetBufferString: String;
var a1:Cardinal;
begin
if mBufferUsed = Zero then
Result:=EmptyString else begin
SetLength(Result,mBufferUsed);
for a1:=Zero to mBufferUsed-One do
Result[a1+One]:=Char(PBytePack(pBuffer)^[a1]); end;
end;
  // Наполнить буффер из этойстроки >
procedure TMyFileStream.SetBufferString(Value: String);
var a1,a2:Cardinal;
begin
a2:=Length(Value);
if a2 > Zero then
if ExpandBufferUntil(a2) then begin
for a1:=One to a2 do
PBytePack(pBuffer)^[a1-One]:=Byte(Value[a1]);
mBufferUsed:=a2; end;
end;
  // Заполнение буффера нулями >
function TMyFileStream.ClearBuffer: Boolean;
begin
if Assigned(pBuffer) then
if mBufferSize = Zero then
Result:=false else try
FillChar(pBuffer^,mBufferSize,Zero);
mBufferUsed:=mBufferSize;
Result:=true; except
Result:=false; end else
Result:=false;
end;
  // Скопировать из буффера >
function TMyFileStream.CopyFromBuffer(pData: Pointer; Size: Cardinal): Boolean;
begin
if pData = nil then // Не действительный указатель >
Result:=false else
if mBufferSize = Zero then // Буффер пуст >
Result:=false else
if mBufferSize < Size then // Затребованные данные "вылазят" за пределы буффера >
Result:=false else begin
Move(pBuffer^,pData^,Size);
Result:=true; end;
end;
  // Скопировать в буффер >
function TMyFileStream.CopyToBuffer(pData: Pointer; Size: Cardinal): Boolean;
var p1:Pointer;
begin
if pData = nil then // Не действительный указатель >
Result:=false else
if Size = Zero then // Ничего не копировать >
Result:=false else
if mBufferSize = Zero then begin // Если у нас ещё нет памяти в буффере >
GetMem(pBuffer,Size);
mBufferSize:=Size;
Move(pData^,pBuffer^,Size);
mBufferUsed:=Size;
Result:=true; end else
if mBufferSize < Size then begin // Если не влазит в имеющийся буффер >
GetMem(p1,Size);
Move(pData^,p1^,Size);
FreeMem(pBuffer,mBufferSize);
pBuffer:=p1;
mBufferSize:=Size;
mBufferUsed:=Size;
Result:=true; end else begin // Если всё влазит >
Move(pData^,pBuffer^,Size);
mBufferUsed:=Size;
Result:=true; end;
end;
  // Удалить\вырезать кусок из буффера >
function TMyFileStream.TakeFromBuffer(Size: Cardinal): Boolean;
begin
if Size = Zero then
Result:=false else
if mBufferSize < Size then
Result:=false else begin
if mBufferUsed-Size > Zero then begin
Move(Pointer(Cardinal(pBuffer)+Size)^,pBuffer^,mBufferUsed-Size);
mBufferUsed:=mBufferUsed-Size; end else
mBufferUsed:=Zero;
Result:=true; end;
end;
  // Узнать 64-битное положение в файле >
function TMyFileStream.GetPos: Int64;
var a1,a2:Cardinal;
begin
a1:=Zero;
a2:=SetFilePointer(mHandle,Zero,@a1,FILE_CURRENT);
Result:=a2 or a1 shl _32;
end;
  // "64-битное" положение в файле >
procedure TMyFileStream.SetPos(Value: Int64);
var a1:Cardinal;
begin
a1:=Value shr _32;
SetFilePointer(mHandle,Cardinal(Value),@a1,FILE_BEGIN);
end;
  // 64-битный размер файла >
function TMyFileStream.GetSize: Int64;
var a1,a2:Cardinal;
begin
a2:=GetFileSize(mHandle,@a1);
Result:=a2 or a1 shl _32;
end;
  // Установить размеры файла >
procedure TMyFileStream.SetSize(Value: Int64);
var a1:Cardinal;
begin
a1:=Value shr _32;
SetFilePointer(mHandle,Cardinal(Value),@a1,FILE_BEGIN);
SetEndOfFile(mHandle);
end;
  // Сдвинуть позицию чтения\записи в начало файла >
function TMyFileStream.GoToBegin: Boolean;
begin
SetFilePointer(mHandle,Zero,nil,FILE_BEGIN);
Result:=true;
end;
  // Сдвинуть позицию чтения\записи в конец файла >
function TMyFileStream.GoToEnd: Boolean;
begin
SetFilePointer(mHandle,Zero,nil,FILE_END);
Result:=true;
end;
  // Прочитать в указатель >
function TMyFileStream.Read(var pData: Pointer; Size: Cardinal): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,pData^,Size,a1,nil) then
Result:=a1 = Size else
Result:=false;
end;
  // Прочитать... >
function TMyFileStream.Read(var Value; Size: Cardinal): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,Size,a1,nil) then
Result:=a1 = Size else
Result:=false;
end;
  // Прочитать в буффер >
function TMyFileStream.Read: Boolean;
begin
if pBuffer = nil then
Result:=false else
if ReadFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
Result:=mBufferUsed = mBufferSize else
Result:=false;
end;
  // Прочитать весь файлв буффер >
function TMyFileStream.ReadAll: Boolean;
begin
ResizeBuffer(GetSize);
if ReadFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
Result:=mBufferUsed = mBufferSize else
Result:=false;
end;
  // Прочитать весь файлв буффер >
function TMyFileStream.ReadAdd(Size: Cardinal): Boolean;
var a1:Cardinal;
begin
if Size = Zero then
Result:=true else
if ExpandBufferUntil(mBufferUsed+Size) then
if ReadFile(mHandle,Pointer(Cardinal(pBuffer)+mBufferSize-Size)^,Size,a1,nil) then begin
mBufferUsed:=mBufferUsed+a1;
Result:=Size = a1; end else
Result:=false else
Result:=false;
end;
  // Прочитать что-то начиная от такой-то позиции >
function TMyFileStream.Read(var Value; nSize: Cardinal; nPosition: Int64): Boolean;
var a1,a2:Cardinal; a3:Int64;
begin
a1:=nPosition shr _32;
a2:=SetFilePointer(mHandle,Cardinal(nPosition),@a1,FILE_BEGIN);
a3:=a2 or a1 shl _32;
if a3 = nPosition then
if ReadFile(mHandle,Value,nSize,a1,nil) then
Result:=nSize = a1 else
Result:=false else
Result:=false;
end;
  // Записать что-то с такой-то позиции >
function TMyFileStream.Write(var Value; nSize: Cardinal; nPosition: Int64): Boolean;
var a1,a2:Cardinal; a3:Int64;
begin
a1:=nPosition shr _32;
a2:=SetFilePointer(mHandle,Cardinal(nPosition),@a1,FILE_BEGIN);
a3:=a2 or a1 shl _32;
if a3 = nPosition then
if WriteFile(mHandle,Value,nSize,a1,nil) then
Result:=nSize = a1 else
Result:=false else
Result:=false;
end;
  // Записать из указателя >
function TMyFileStream.Write(var pData: Pointer; Size: Cardinal): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,pData^,Size,a1,nil) then
Result:=a1 = Size else
Result:=false;
end;
  // Записать из буффера >
function TMyFileStream.Write(var Value; Size: Cardinal): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,Size,a1,nil) then
Result:=a1 = Size else
Result:=false;
end;
  // Записать из буффера >
function TMyFileStream.Write: Boolean;
begin
if pBuffer = nil then
Result:=false else
if WriteFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
Result:=mBufferUsed = mBufferSize else
Result:=false;
end;
  // Прочитать в нультерминальную строку >
function TMyFileStream.Read(var pData: PChar): Boolean;
var a1,a2:Cardinal;
begin
if ReadFile(mHandle,a1,cCardinalSize,a2,nil) then
if a2 = cCardinalSize then
if a1 = Zero then begin
pData:=nil;
Result:=true; end else begin
if Assigned(pData) then begin
a2:=Zero;
while PBytePack(pData)^[a2] <> Zero do
Inc(a2);
FreeMem(pData,a2+One); end;
GetMem(pData,a1+One);
PBytePack(pData)^[a1]:=Zero;
if ReadFile(mHandle,pData,a1,a2,nil) then
Result:=a2 = a1 else
Result:=false; end else
Result:=false else
Result:=false;
end;
  // Записать нультерминальную строку >
function TMyFileStream.Write(var pData: PChar): Boolean;
var a1,a2:Cardinal;
begin
a1:=Zero;
if Assigned(pData) then
while PBytePack(pData)^[a1] <> Zero do
Inc(a1);
if WriteFile(mHandle,a1,cCardinalSize,a2,nil) then
if a2 = cCardinalSize then
if a1 = Zero then
Result:=true else
if WriteFile(mHandle,pData^,a1,a2,nil) then
Result:=a1 = a2 else
Result:=false else
Result:=false else
Result:=false;
end;
  // Читаем слово >
function TMyFileStream.Read(var Value: Word): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cWordSize,a1,nil) then
Result:=a1 = cWordSize else
Result:=false;
end;
  // Читаем байт >
function TMyFileStream.Read(var Value: Byte): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cByteSize,a1,nil) then
Result:=a1 = cByteSize else
Result:=false;
end;
  // Читаем действительное >
function TMyFileStream.Read(var Value: Cardinal): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cCardinalSize,a1,nil) then
Result:=a1 = cCardinalSize else
Result:=false;
end;
  // Читаем действительное >
function TMyFileStream.ReadCardinal: Cardinal;
var a1:Cardinal;
begin
ReadFile(mHandle,Result,cCardinalSize,a1,nil);
end;
  // Пишем действительное >
function TMyFileStream.WriteCardinal(Value: Cardinal): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cCardinalSize,a1,nil) then
Result:=cCardinalSize = a1 else
Result:=false;
end;
  // Читаем целое >
function TMyFileStream.Read(var Value: Integer): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cIntegerSize,a1,nil) then
Result:=a1 = cIntegerSize else
Result:=false;
end;
  // Пишем слово >
function TMyFileStream.Write(var Value: Word): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cWordSize,a1,nil) then
Result:=a1 = cWordSize else
Result:=false;
end;
  // Пишем байт >
function TMyFileStream.Write(var Value: Byte): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cByteSize,a1,nil) then
Result:=a1 = cByteSize else
Result:=false;
end;
  // Пишем действительное >
function TMyFileStream.Write(var Value: Cardinal): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cCardinalSize,a1,nil) then
Result:=a1 = cCardinalSize else
Result:=false;
end;
  // Пишем целое >
function TMyFileStream.Write(var Value: Integer): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cIntegerSize,a1,nil) then
Result:=a1 = cIntegerSize else
Result:=false;
end;
  // Прочитать "нормальную" строку >
function TMyFileStream.Read(var Value: String): Boolean;
var a1,a2:Cardinal;
begin
if ReadFile(mHandle,a1,cCardinalSize,a2,nil) then
if a2 = cCardinalSize then
if a1 = Zero then begin
Value:=EmptyString;
Result:=true; end else begin
ResizeBuffer(a1);
if ReadFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
if mBufferSize = mBufferUsed then begin
SetLength(Value,a1);
for a2:=One to a1 do
Value[a2]:=Char(PBytePack(pBuffer)^[a2-One]);
Result:=true; end else
Result:=false else
Result:=false; end else
Result:=false else
Result:=false;
end;
  // Возвращает результатом прочитанную строчку >
function TMyFileStream.ReadString: String;
var a1,a2:Cardinal;
begin
if ReadFile(mHandle,a1,cCardinalSize,a2,nil) then
if a2 = cCardinalSize then
if a1 = Zero then
Result:=EmptyString else begin
ResizeBuffer(a1);
if ReadFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
if mBufferSize = mBufferUsed then begin
SetLength(Result,a1);
for a2:=One to a1 do
Result[a2]:=Char(PBytePack(pBuffer)^[a2-One]); end else
Result:=EmptyString else
Result:=EmptyString; end else
Result:=EmptyString else
Result:=EmptyString;
end;
  // Записать "обычную" строку >
function TMyFileStream.Write(const Value: String): Boolean;
var a1,a2:Cardinal;
begin
a1:=Length(Value);
if WriteFile(mHandle,a1,cCardinalSize,a2,nil) then
if a2 = cCardinalSize then
if a1 = Zero then
Result:=true else begin
ResizeBuffer(a1);
for a2:=One to a1 do
PBytePack(pBuffer)^[a2-One]:=Byte(Value[a2]);
if WriteFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
Result:=mBufferSize = mBufferUsed else
Result:=false; end else
Result:=false else
Result:=false;
end;
  // Читаем большое целое >
function TMyFileStream.Read(var Value: Int64): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cInt64Size,a1,nil) then
Result:=a1 = cInt64Size else
Result:=false;
end;
  // Читаем вещественное число >
function TMyFileStream.Read(var Value: Single): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cSingleSize,a1,nil) then
Result:=a1 = cSingleSize else
Result:=false;
end;
  // Читаем булево значение >
function TMyFileStream.Read(var Value: Boolean): Boolean;
var a1:Cardinal; b1:Byte;
begin
if ReadFile(mHandle,b1,cByteSize,a1,nil) then
Result:=a1 = cByteSize else
Result:=false;
if b1 = Zero then
Value:=false else
Value:=true;
end;
  // Пишем большое целое >
function TMyFileStream.Write(var Value: Int64): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cInt64Size,a1,nil) then
Result:=a1 = cInt64Size else
Result:=false;
end;
  // Пишем вещественное число >
function TMyFileStream.Write(var Value: Single): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cSingleSize,a1,nil) then
Result:=a1 = cSingleSize else
Result:=false;
end;
  // Пишем булево значение >
function TMyFileStream.Write(var Value: Boolean): Boolean;
var a1:Cardinal; b1:Byte;
begin
if Value then
b1:=One else
b1:=Zero;
if WriteFile(mHandle,b1,cByteSize,a1,nil) then
Result:=a1 = cByteSize else
Result:=false;
end;
  // Сделать всё содержимое буффера "активным" >
function TMyFileStream.ActivateBuffer: Boolean;
begin
if mBufferSize = Zero then
Result:=false else begin
mBufferUsed:=mBufferSize;
Result:=true; end;
end;
  // Установить сколько использовано буффера в ручную >
procedure TMyFileStream.SetBufferUsed(Value: Cardinal);
begin
if Value > mBufferSize then
mBufferUsed:=mBufferSize else
mBufferUsed:=Value;
end;
  // Прочитать строчку (текстовый формат файла) >
function TMyFileStream.ReadLn(var Value: String): Boolean;
var b1,b2:Byte; a1,a2:Cardinal;
begin
Result:=true; // Обязательно нужно что-то с этим сделать 8-/ >
Value:=EmptyString;
while true do
if ReadFile(mHandle,b1,cByteSize,a1,nil) and (a1 = cByteSize) then
if b1 = mEndLine then
if ReadFile(mHandle,b2,cByteSize,a2,nil) and (a2 = cByteSize) then
if b2 = mnBreakLine then begin
Result:=true;
Break; end else
Value:=Value+Char(b1)+Char(b2) else begin
Value:=Value+Char(b1);
Result:=true;
Break; end else
Value:=Value+Char(b1) else begin
Result:=false;
Break; end;
if Length(Value) > Zero then
Result:=true;
end;
  // Записать строчку (текстовый формат файла) >
function TMyFileStream.WriteLn(const Value: String): Boolean;
var a1,a2,a3:Cardinal;
begin
a2:=Length(Value);
a3:=a2+Two;
if mBufferSize < a3 then
ResizeBuffer(a3);
for a1:=One to a2 do
PBytePack(pBuffer)^[a1-One]:=Byte(Value[a1]);
PBytePack(pBuffer)^[a2]:=mEndLine;
PBytePack(pBuffer)^[a2+One]:=mnBreakLine;
if WriteFile(mHandle,pBuffer^,a3,a1,nil) then
Result:=a1 = a3 else
Result:=false;
end;
//=============================================================================>
//============================== TMyWAVStream =================================>
//=============================================================================>
constructor TMyWAVStream.Create;
begin
inherited Create;
pWAVHeader:=@mWAVHeader;
ReBuildBuffer(cUsualAudioBufferSize); // "Стандартный" размер буффера для хранения звука >
end;
  // Деструктор >
destructor TMyWAVStream.Destroy;
begin
inherited Destroy;
end;
  // Проверка ликвидности + проверка заголовка >
function TMyWAVStream.Check: Boolean;
begin
if inherited Check then
with mWAVHeader do
if UpperCase(ChunkID) = mRIFF then
if ChunkSize = Size-Eight then
if UpperCase(Format) = mR_WAV then
Result:=AudioFormat = One else
Result:=false else
Result:=false else
Result:=false else
Result:=false;
end;
  // Копировать заголовок >
procedure TMyWAVStream.SetHeader(pData: PMyWAVHeader);
begin
if pData <> nil then
if pData <> pWAVHeader then
mWAVHeader:=pData^;
end;
  // Записать заголовок >
function TMyWAVStream.WriteHeader: Boolean;
begin
with mWAVHeader do begin
ChunkID:=mRIFF;
ChunkSize:=Size-Eight;
Format:=mR_WAV;
SubChunk1ID:=mR_SC1ID;
SubChunk1Size:=_16;
AudioFormat:=One;
ByteRate:=SampleRate*NumChannels*BitsPerSample div Eight;
BlockAlign:=NumChannels*BitsPerSample div Eight;
SubChunk2ID:=mR_DATA;
SubChunk2Size:=Size-mWAVHeaderSize; end;
Result:=Write(mWAVHeader,mWAVHeaderSize);
end;
  // Запись данных в WAV-файл >
function TMyWAVStream.WriteWAVData(var pData: Pointer; Size: Cardinal): Boolean;
begin
if pData = nil then
Result:=false else
if Size = Zero then
Result:=false else
if Write(pData^,Size) then begin
GoToBegin;
Result:=WriteHeader;
GoToEnd; end else
Result:=false;
end;
  // Открыть для чтения >
function TMyWAVStream.OpenRead(Path: PChar): Boolean;
begin
if inherited OpenRead(Path) then
if Read(mWAVHeader,mWAVHeaderSize) then
Result:=Check else
Result:=false else
Result:=false;
end;
  // Прочитать весь "звук" из файла в буффер >
function TMyWAVStream.ReadAll: Boolean;
begin
ReBuildBuffer(mWAVHeader.SubChunk2Size);
Result:=Read;
end;
  // Открыть для записи >
function TMyWAVStream.OpenWrite(Path: PChar): Boolean;
begin
if inherited OpenWrite(Path) then begin
WriteHeader;
Result:=Check end else
Result:=false;
end;
//=============================================================================>
//=================================== TMyLog ==================================>
//=============================================================================>
constructor TMyLog.Create(Path: String);
begin // Конструктор >
inherited Create;
mFileName:=Path; // ShowMessage(mFileName);
end;
  // Деструктор >
destructor TMyLog.Destroy;
begin
inherited Destroy;
end;
  // Очистить файл >
procedure TMyLog.ClearLog;
begin
CreateWrite(PChar(mFileName));
Close;
end;
  // Пустую строчку >
procedure TMyLog.WriteLog;
begin
WriteLog(EmptyString);
end;
  // Записать свою строчку >
procedure TMyLog.WriteLog(Value: String);
var p1:PMyTime; s1:String;
begin // Вот, через неё и будем записывать, все перегрузки 8-) >
if OpenWrite(PChar(mFileName)) then begin // ShowMessage(mFileName);
GoToEnd;
UpDatePMyTime(p1);
with p1^ do
s1:=IntToStr(bHour)+mnTwoDots+IntToStr(bMinute)+mnTwoDots+IntToStr(bSecond)+mDivOfCom+Value;
WriteLn(s1);
Dispose(p1);
Close; end;
end;
  // Записать строчку из списка >
procedure TMyLog.WriteLog(Index: Cardinal);
begin
WriteLog(Line[Index]);
end;
  // Записать строчку и цифру >
procedure TMyLog.WriteLog(Index,Value: Cardinal);
begin
WriteLog(Line[Index]+mDivOfCom+IntToStr(Value));
end;
  // Совместить >
procedure TMyLog.WriteLog(Index: Cardinal; AdditionalValue: String);
begin
if Count > Index then
WriteLog(Line[Index]+mDivOfCom+AdditionalValue) else
WriteLog(AdditionalValue);
end;
  // Совместить >
procedure TMyLog.WriteLog(Index: Cardinal; AdditionalValue: String; Result: Boolean);
begin
if Result then
WriteLog(Line[Index]+mDivOfCom+AdditionalValue+mDivOfCom+Line[mnl_YES]) else
WriteLog(Line[Index]+mDivOfCom+AdditionalValue+mDivOfCom+Line[mnl_NO]);
end;
  // Записать коментарии плюс "цифру" >
procedure TMyLog.WriteLog(Coment: String; Value: Integer);
begin
WriteLog(Coment+mDivOfCom+IntToStr(Value));
end;
//=============================================================================>
//==================================== TMyHardDriveDataTree =================================>
//=============================================================================>
constructor TMyHardDriveDataTree.Create;
begin // Конструктор >
inherited Create;
SetLength(mNodesBuff,Zero);
mNodesBuffCount:=Zero;
mNodesBuffHigh:=mOne;
mNodesBuffCap:=Zero;
mNodesScanRange:=Zero;
end;
  // Деструктор >
destructor TMyHardDriveDataTree.Destroy;
begin
Close;
inherited Destroy;
end;                                          
  // "Очистить\приготовить" общую часть всех "упаковок" >
procedure TMyHardDriveDataTree.ClearUsualPack;
var p1:PMyTime;
begin
with PMyHDMLinkPack(pCrntPointer)^.U do begin
p1:=@Create;
UpDatePMyTime(p1);
Edit:=Create;
View:=Create;
UseCount:=Zero;
UseType:=Zero;
Active:=true;
InUse:=false;
ParentNode:=mOne; end;
end;
  // Прочистить заготовку "описания" >
procedure TMyHardDriveDataTree.ClearDescription;
begin
with PMyHDMNodeDescription(pCrntPointer)^ do begin
ParentDescription:=mOne;
ChildDescription:=mOne;
Size:=Zero; end;
ClearUsualPack;
end;
  // Прочистка заготовки "узла" >
procedure TMyHardDriveDataTree.ClearNode;
var a1:Cardinal;
begin
with PMyHDMNodePack(pCrntPointer)^ do begin
for a1:=Zero to ByteMax do
Nodes[a1]:=mOne;
ParentIndex:=mOne;
Link:=mOne;
Description:=mOne;
Extra:=mOne;
Reserved:=mOne; end;
ClearUsualPack;
end;
  // Подготовка "верховного заголовка" >
procedure TMyHardDriveDataTree.ClearHeader;
var a1:Cardinal;
begin
with PMyHDMHeaderPack(pCrntPointer)^ do begin
with Authorisation do begin
Shift:=Random(ByteLength);
for a1:=Zero to ByteMax do
Login[a1]:=Zero;
for a1:=Zero to ByteMax do
Password[a1]:=Zero; end;
for a1:=Zero to ByteMax do
EditionReserverd[a1]:=mOne; end;
ClearNode;
end;
  // Открыть\подключиться к файлу БД >
function TMyHardDriveDataTree.Load(pPath: PChar = nil): Boolean;
var p1:PMyTime;
begin
if pPath = nil then
Result:=false else
if UnViewMap then
if OpenReadWrite(pPath) then
if Size < cMyHDMHeaderPack then begin
Size:=cMyHDMHeaderPack;
if MapView(Zero,cMyHDMHeaderPack) then begin
ClearHeader;
Result:=true; end else
Result:=false; end else
Result:=MapView(Zero,cMyHDMHeaderPack) else
Result:=false else
Result:=false;
if Result then // При подключении к "БД" обновляем "статистику" >
with mStatistic do begin
NodesAdded:=Zero;
LinksMade:=Zero;
DescriptionCreated:=Zero;
Views:=Zero;
p1:=@Time;
UpDatePMyTime(p1);
ParentPack:=PMyHDMHeaderPack(pCrntPointer)^.StatisticEnd;
ChildPack:=mOne; end;
end;
  // Начало обновления >
function TMyHardDriveDataTree.BeginUpDate: Boolean;
begin
if Check then begin
mNodesBuffDepth:=Zero;
GetNodeBuff(mNodesBuffDepth);
Result:=true; end else
Result:=false;
end;
  // Конец обновления >
procedure TMyHardDriveDataTree.EndUpDate;
begin
mNodesBuffDepth:=Zero;
ClearNodesBuff;
Inc(mStatistic.Views);
end;
  // Проверка доступа к базе данных >
function TMyHardDriveDataTree.Check: Boolean;
begin
if inherited Check then
Result:=Size >= cMyHDMHeaderPack else
Result:=false;
end;
  // Добавить к базе данных узел >
function TMyHardDriveDataTree.NodeAdd(Value: String): Boolean;
var a1,a2:Cardinal; v1,v2:Int64;
begin
a2:=Length(Value);
if a2 = Zero then
Result:=false else
if BeginUpDate then
if MapView(Zero,cMyHDMNodePack) then begin
v1:=Zero;
for a1:=One to a2 do begin
v2:=PMyHDMNodePack(pCrntPointer)^.Nodes[Byte(Value[a1])];
if v2 = mOne then begin
v2:=Size;
PMyHDMNodePack(pCrntPointer)^.Nodes[Byte(Value[a1])]:=v2;
Size:=v2+cMyHDMNodePack;
MapView(v2,cMyHDMNodePack);
ClearNode;
PMyHDMNodePack(pCrntPointer)^.ParentIndex:=Byte(Value[a1]);
PMyHDMNodePack(pCrntPointer)^.U.ParentNode:=v1;
v1:=v2; end else begin
MapView(v2,cMyHDMNodePack);
v1:=v2; end; end;
PMyHDMNodePack(pCrntPointer)^.U.UseType:=One;
PMyHDMNodePack(pCrntPointer)^.U.UseCount:=PMyHDMNodePack(pCrntPointer)^.U.UseCount+One;
Inc(mStatistic.NodesAdded);
Result:=UnViewMap;
EndUpDate; end else
Result:=false else
Result:=false;
end;
  // Добавить целый список строк >
function TMyHardDriveDataTree.NodeAdd(Value: TMyStringList): Boolean;
var a1,a2,a3:Cardinal; v1,v2:Int64; s1:String;
begin            
if Value = nil then
Result:=false else
if Value.Count = Zero then
Result:=false else
if BeginUpDate then begin
for a3:=Zero to Value.Max do begin
s1:=Value.Line[a3];
a2:=Length(s1);
if a2 > Zero then
if MapView(Zero,cMyHDMNodePack) then begin
v1:=Zero;
for a1:=One to a2 do begin
v2:=PMyHDMNodePack(pCrntPointer)^.Nodes[Byte(s1[a1])];
if v2 = mOne then begin
v2:=Size;
PMyHDMNodePack(pCrntPointer)^.Nodes[Byte(s1[a1])]:=v2;
Size:=v2+cMyHDMNodePack;
MapView(v2,cMyHDMNodePack);
ClearNode;
PMyHDMNodePack(pCrntPointer)^.ParentIndex:=Byte(s1[a1]);
PMyHDMNodePack(pCrntPointer)^.U.ParentNode:=v1;
v1:=v2; end else begin
MapView(v2,cMyHDMNodePack);
v1:=v2; end; end;
PMyHDMNodePack(pCrntPointer)^.U.UseType:=One;
PMyHDMNodePack(pCrntPointer)^.U.UseCount:=PMyHDMNodePack(pCrntPointer)^.U.UseCount+One;
Inc(mStatistic.NodesAdded); end; end;
Result:=UnViewMap;
EndUpDate; end else
Result:=false;
end;
  // Позиция "узла" в файле >
function TMyHardDriveDataTree.NodePosition(Value: String): Int64;
var a1,a2,a3:Cardinal; v1,v2:Int64;
begin
a2:=Length(Value);
if a2 = Zero then
Result:=mOne else
if MapView(Zero,cMyHDMNodePack) then begin
v1:=Zero;
a3:=Zero;
for a1:=One to a2 do begin
v2:=PMyHDMNodePack(pCrntPointer)^.Nodes[Byte(Value[a1])];
if v2 = mOne then
Break else begin
if MapView(v2,cMyHDMNodePack) then
Inc(a3);
v1:=v2; end; end;
if a3 = a2 then
Result:=v1 else
Result:=mOne;
UnViewMap; end else
Result:=mOne;
end;
  // Параметры "узла" по его "адресу" >
function TMyHardDriveDataTree.NodeParams(Value: Int64): PMyHDMNodePack;
begin
if Check then
if MapView(Value,cMyHDMNodePack) then
Result:=pCrntPointer else
Result:=nil else
Result:=nil;
end;
  // Есть-ли такой "узел" >
function TMyHardDriveDataTree.NodeExists(Value: String): Boolean;
var a1,a2,a3:Cardinal; v1:Int64;
begin
a2:=Length(Value);
if a2 = Zero then
Result:=false else
if Check then
if MapView(Zero,cMyHDMNodePack) then begin
a3:=Zero;
for a1:=One to a2 do begin
v1:=PMyHDMNodePack(pCrntPointer)^.Nodes[Byte(Value[a1])];
if v1 = mOne then
Break else
if MapView(v1,cMyHDMNodePack) then
Inc(a3); end;
Result:=a3 = a2;
UnViewMap; end else
Result:=false else
Result:=false;
Inc(mStatistic.Views);
end;
  // Путь\Имя узла, по его физическому адресу >
function TMyHardDriveDataTree.NodePath(Value: Int64): String;
var v1:Int64; v2:SmallInt;
begin
Result:=EmptyString;
if Check then
if Value <= (Size-cMyHDMNodePack) then
if MapView(Value,cMyHDMNodePack) then begin
v1:=PMyHDMNodePack(pCrntPointer)^.U.ParentNode;
v2:=PMyHDMNodePack(pCrntPointer)^.ParentIndex;
Result:=Char(v2)+Result;
while (v1 > Zero) and (v2 > Zero) do
if MapView(v1,cMyHDMNodePack) then begin
v1:=PMyHDMNodePack(pCrntPointer)^.U.ParentNode;
v2:=PMyHDMNodePack(pCrntPointer)^.ParentIndex;
Result:=Char(v2)+Result; end else
Break;
UnViewMap; end;
end;
  // Добыть все "узлы" из файла БД в список строк (рекурсивная "лошадка") >
procedure TMyHardDriveDataTree.NodeExtract(Value: Int64);
var a1:Cardinal; p1:PMyHDMNodePack;
begin
if MapView(Value,cMyHDMNodePack) then begin
Inc(mNodesBuffDepth);
p1:=GetNodeBuff(mNodesBuffDepth);
Move(pCrntPointer^,p1^,cMyHDMNodePack);
if p1^.U.UseType = One then
vAdditional1.Add(NodePath(Value));
for a1:=Zero to ByteMax do
if p1^.Nodes[a1] > mOne then
NodeExtract(p1^.Nodes[a1]);
Dec(mNodesBuffDepth); end;
end;
  // Добыть все "узлы" из файла БД в список строк (пользовательский вариант) >
function TMyHardDriveDataTree.NodeExtract(Value: TMyStringList): Boolean;
begin
if Value = nil then
Result:=false else
if BeginUpDate then
if Value.Clear then begin
vAdditional1:=Value;
NodeExtract(Zero);
EndUpDate;
UnViewMap;
Result:=Value.Count > Zero; end else
Result:=false else
Result:=false;
end;
  // Рекурсивный "счётчик-обходитель" >
function TMyHardDriveDataTree.NodeCount(Value: Int64): Int64;
var a1:Cardinal; p1:PMyHDMNodePack;
begin
if MapView(Value,cMyHDMNodePack) then begin
Inc(mNodesBuffDepth);
p1:=GetNodeBuff(mNodesBuffDepth);
Move(pCrntPointer^,p1^,cMyHDMNodePack);
if p1^.U.UseType = One then
Result:=One else
Result:=Zero;
for a1:=Zero to ByteMax do
if p1^.Nodes[a1] > mOne then
Result:=Result+NodeCount(p1^.Nodes[a1]);
Dec(mNodesBuffDepth); end else
Result:=Zero;
end;
  // Функция возвращает (очень долго!) количество узлов в файле >
function TMyHardDriveDataTree.NodeCount: Int64;
begin
if BeginUpDate then
if Size < cMyHDMNodePack then
Result:=Zero else begin
Result:=NodeCount(Zero);
EndUpDate; end else
Result:=Zero;
end;
  // Рекурсивный "счётчик-добавитель" >
procedure TMyHardDriveDataTree.NodeGetNearestNames(Value: Int64);
var a1:Cardinal; p1:PMyHDMNodePack;
begin
if MapView(Value,cMyHDMNodePack) then begin
Inc(mNodesBuffDepth);
p1:=GetNodeBuff(mNodesBuffDepth);
Move(pCrntPointer^,p1^,cMyHDMNodePack);
if p1^.U.UseType = One then
vAdditional1.Add(NodePath(Value));
if (mNodesScanRange = Zero) or (vAdditional1.Count < mNodesScanRange) then
for a1:=Zero to ByteMax do
if p1^.Nodes[a1] > mOne then
NodeGetNearestNames(p1^.Nodes[a1]);
Dec(mNodesBuffDepth); end;
end;
  // Добыить ближайшие "имена" "узлов", от указанного в строке... >
function TMyHardDriveDataTree.NodeGetNearestNames(cNode: Int64; cList: TMyStringList; cCount: Cardinal = Zero): Boolean;
begin
if cNode = mOne then
Result:=false else
if cList = nil then
Result:=false else
if BeginUpDate then begin
vAdditional1:=cList;
mNodesScanRange:=cCount;
NodeGetNearestNames(cNode);
Result:=cList.Count > Zero;
EndUpDate; end else
Result:=false;
end;
  // Уничтожить временный буффер для "узлов", используемый при рекурсивном обходе >
procedure TMyHardDriveDataTree.ClearNodesBuff;
var a1:Cardinal;
begin
if mNodesBuffCount > Zero then begin
for a1:=Zero to mNodesBuffHigh do
FreeMem(mNodesBuff[a1],cMyHDMNodePack);
SetLength(mNodesBuff,Zero);
mNodesBuffHigh:=mOne;
mNodesBuffCount:=Zero;
mNodesBuffCap:=Zero; end;
end;
  // Получить указатель на место в буффере для хранения "узла" >
function TMyHardDriveDataTree.GetNodeBuff(Index: Cardinal): Pointer;
begin
if Integer(Index) > mNodesBuffHigh then
SetNodeBuffCount(Index+One);
Result:=mNodesBuff[Index];
end;
  // Устанавливает ёмкость буффера "узлов" >
procedure TMyHardDriveDataTree.SetNodeBuffCount(Value: Cardinal);
var a1,a2:Cardinal;
begin
if Value <> mNodesBuffCount then begin
a2:=((Value div _64)+One)*_64;
if a2 <> mNodesBuffCap then begin
SetLength(mNodesBuff,a2);
for a1:=mNodesBuffCap to a2-One do
GetMem(mNodesBuff[a1],cMyHDMNodePack);
mNodesBuffCap:=a2; end;
mNodesBuffCount:=Value;
mNodesBuffHigh:=Value-One; end;
end;
  // Очистить всю базу "под ноль" >
function TMyHardDriveDataTree.Clear: Boolean;
begin
if FileExists(pPath) then
if UnViewMap and Close then
if DeleteFile(pPath) then
if OpenReadWrite(pPath) then begin
Size:=cMyHDMHeaderPack;
if MapView(Zero,cMyHDMHeaderPack) then begin
ClearHeader;
Result:=true; end else
Result:=false; end else
Result:=false else
Result:=false else
Result:=false else
Result:=false;
end;
  // Отключение от "файла БД" >
function TMyHardDriveDataTree.Close: Boolean;
var v1:Int64;
begin
if MapView(mStatistic.ParentPack,cMyHDMStatisticPack) then begin
v1:=Size;
PMyHDMStatisticPack(pCrntPointer)^.ChildPack:=v1;
Size:=v1+cMyHDMStatisticPack;
if MapView(v1,cMyHDMStatisticPack) then begin
Move(mStatistic,pCrntPointer^,cMyHDMStatisticPack);
if MapView(Zero,cMyHDMHeaderPack) then
PMyHDMHeaderPack(pCrntPointer)^.StatisticEnd:=v1; end; end;
if UnViewMap then
Result:=inherited Close else
Result:=false;
end;
  // Возвращает указатель на последнюю записанную на диске запись "статистики" >
function TMyHardDriveDataTree.LastStatisticRecord: PMyHDMStatisticPack;
begin
if BeginUpDate then
if MapView(mStatistic.ParentPack,cMyHDMStatisticPack) then begin
Result:=pCrntPointer;
EndUpDate; end else
Result:=nil else
Result:=nil;
end;
  // Возвращает указатель на текущую запись "статистики" >
function TMyHardDriveDataTree.CrntStatisticRecord: PMyHDMStatisticPack;
begin
if BeginUpDate then begin
Result:=@mStatistic;
EndUpDate; end else
Result:=nil;
end;
  // Прочистка заготовки "связи" >
procedure TMyHardDriveDataTree.ClearLink;
var a1:Cardinal;
begin
with PMyHDMLinkPack(pCrntPointer)^ do begin
ParentLink:=mOne;
ChildLink:=mOne;
for a1:=Zero to ByteMax do
LinkedNodes[a1]:=mOne;
for a1:=Zero to ByteMax do
LinkFlags[a1]:=Zero;
for a1:=Zero to ByteMax do
LinkUsage[a1]:=Zero; end;
ClearUsualPack;
end;
  // Параметры "связи" по его "адресу" >
function TMyHardDriveDataTree.LinkParams(Value: Int64): PMyHDMlinkPack;
begin
if Check then
if MapView(Value,cMyHDMLinkPack) then
Result:=pCrntPointer else
Result:=nil else
Result:=nil;
end;
  // Возвращает "ДА", если у первого указанного узла есть ссылка на второй >
function TMyHardDriveDataTree.Linked(FirstNode,SecondNode: Int64): Boolean;
var v1:Int64; a1:Cardinal;
begin
Result:=false;
if FirstNode = mOne then
Exit else
if SecondNode = mOne then
Exit else
if FirstNode = SecondNode then
Exit else
if MapView(FirstNode,cMyHDMNodePack) then
v1:=PMyHDMNodePack(pCrntPointer)^.Link else
v1:=mOne;
while v1 > mOne do
if MapView(v1,cMyHDMLinkPack) then begin
for a1:=Zero to ByteMax do
if PMyHDMLinkPack(pCrntPointer)^.LinkedNodes[a1] = SecondNode then begin
Result:=true;
Break; end else
if PMyHDMLinkPack(pCrntPointer)^.LinkedNodes[a1] = mOne then
Break;
if Result then
Break else
v1:=PMyHDMLinkPack(pCrntPointer)^.ChildLink; end else
Break;
Inc(mStatistic.Views);
end;
  // Добавляет "ссылку" на второй узел в список первого >
function TMyHardDriveDataTree.Link(FirstNode,SecondNode: Int64): Boolean;
var v1,v2:Int64; a1,a2:Cardinal;
begin
Result:=false;
if FirstNode = SecondNode then
Exit else
if FirstNode = mOne then
Exit else
if SecondNode = mOne then
Exit else
if MapView(FirstNode,cMyHDMNodePack) then
v1:=PMyHDMNodePack(pCrntPointer)^.Link else
Exit;
a2:=Zero;
if v1 = mOne then begin // Если у "узла" связей нет вообще >
v2:=Size;
PMyHDMNodePack(pCrntPointer)^.Link:=v2;
Size:=v2+cMyHDMLinkPack;
if MapView(v2,cMyHDMLinkPack) then begin
ClearLink;
with PMyHDMLinkPack(pCrntPointer)^ do begin
U.ParentNode:=FirstNode;
LinkedNodes[a2]:=SecondNode;
LinkFlags[a2]:=One;
LinkUsage[a2]:=One; end;
Result:=UnViewMap; end;
Exit; end;
v2:=v1; // Записываем сюда на всякий случай первый полученный адрес >
while v1 > mOne do // Обходим всю вложенность ссылок в поисках, а не упоминается-ли где-нибудь уже второй узел :) >
if MapView(v1,cMyHDMLinkPack) then begin
v2:=v1;
for a1:=Zero to ByteMax do begin
a2:=a1;
if PMyHDMLinkPack(pCrntPointer)^.LinkedNodes[a1] = SecondNode then begin
Result:=true;
Break; end else
if PMyHDMLinkPack(pCrntPointer)^.LinkedNodes[a1] = mOne then
Break; end;
if Result then
Break else
v1:=PMyHDMLinkPack(pCrntPointer)^.ChildLink; end else begin
Break;
Exit; end;
if not Result then // Если в имеющихся списках "ссылок" нет адреса второго "узла" >
if a2 < ByteMax then // Если списки не заполнены, то дописываем просто новый "узел" >
with PMyHDMLinkPack(pCrntPointer)^ do begin
LinkedNodes[a2]:=SecondNode;
LinkFlags[a2]:=Zero;
LinkUsage[a2]:=One;
Result:=true; end else begin // Если в списке "ссылок" больше нет места, то создаём новую >
v1:=Size;
PMyHDMLinkPack(pCrntPointer)^.ChildLink:=v1;
Size:=v1+cMyHDMLinkPack;
if MapView(v1,cMyHDMLinkPack) then begin
ClearLink;
a2:=Zero;
with PMyHDMLinkPack(pCrntPointer)^ do begin
ParentLink:=v2;
U.ParentNode:=FirstNode;
LinkedNodes[a2]:=SecondNode;
LinkFlags[a2]:=One;
LinkUsage[a2]:=One; end;
Result:=UnViewMap; end else
Result:=false; end;
if Result then
Inc(mStatistic.LinksMade);
end;
  // Помещает имена всех узлов, на которые имеются ссылки у первого укзанного >
function TMyHardDriveDataTree.Links(cNode: Int64; cList: TMyStringList; cCount: Cardinal = Zero): Boolean;
var v1:Int64; a1:Cardinal; p1:PMyHDMLinkPack;
begin
if cNode < Zero then
Result:=false else
if cList = nil then
Result:=false else
if cList.Clear then
if MapView(cNode,cMyHDMNodePack) then begin
v1:=PMyHDMNodePack(pCrntPointer)^.Link;
while v1 > mOne do
if (cCount > Zero) and (cList.Count > cCount) then
Break else
if MapView(v1,cMyHDMLinkPack) then begin
GetMem(p1,cMyHDMLinkPack);
Move(pCrntPointer^,p1^,cMyHDMLinkPack);
v1:=p1^.ChildLink;
for a1:=Zero to ByteMax do
if p1^.LinkedNodes[a1] > mOne then
cList.Add(NodePath(p1^.LinkedNodes[a1]));
FreeMem(p1,cMyHDMLinkPack); end else
Break;
Result:=cList.Count > Zero; end else
Result:=false else
Result:=false;
Inc(mStatistic.Views);
end;
  // >
function TMyHardDriveDataTree.LinksCount(cNode: Int64): Int64;
var v1:Int64; a1:Cardinal; p1:PMyHDMLinkPack;
begin
Result:=Zero;
if cNode > mOne then
if MapView(cNode,cMyHDMNodePack) then begin
v1:=PMyHDMNodePack(pCrntPointer)^.Link;
while v1 > mOne do
if MapView(v1,cMyHDMLinkPack) then begin
GetMem(p1,cMyHDMLinkPack);
Move(pCrntPointer^,p1^,cMyHDMLinkPack);
v1:=p1^.ChildLink;
for a1:=Zero to ByteMax do
if p1^.LinkedNodes[a1] > mOne then
Result:=Result+One else
Break;
FreeMem(p1,cMyHDMLinkPack); end else
Break; end;
Inc(mStatistic.Views);
end;
//=============================================================================>
//================================= Конец модуля ==============================>
//=============================================================================>
end.
