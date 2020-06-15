GHelper = GHelper or {};

print( '[GHelper] Initialization of the addon...' );

local function GetAddonFilelist( DirectoryPath )
    local FileList = {};
    local Files, Dirs = file.Find( DirectoryPath .. '/*', 'LUA' );

    for _, FileName in pairs( Files ) do
        local FileType = string.lower( string.sub( FileName, 1, 2 ) );
        FileList[ string.lower( DirectoryPath .. '/' .. FileName ) ] = FileType;
    end;

    for _, DirName in pairs( Dirs ) do
        local FileListTemp = GetAddonFilelist( DirectoryPath .. '/' .. DirName );

        for FilePath, Type in pairs( FileListTemp ) do
            FileList[ FilePath ] = Type;
        end;
    end;

    return FileList;
end;

local AddonFileList = GetAddonFilelist( 'ghelper_root' );

for FilePath, Type in pairs( AddonFileList ) do
    print( '[GHelper] Loading script -> ' .. FilePath );

    if ( SERVER ) then
        if ( Type ~= 'sv' ) then
            AddCSLuaFile( FilePath );
        end;
        
        if ( Type == 'sv' or Type == 'sh' ) then
            include( FilePath );
            print( '[ALSR] Execute script ---> ' .. FilePath );
        end;
    elseif ( CLIENT ) then
        if ( Type == 'cl' or Type == 'sh' ) then
            include( FilePath );
            print( '[GHelper] Execute script ---> ' .. FilePath );
        end;
    end;
end;

print( '[GHelper] Addon is initialized!' );

AddonFileList = nil;
GetAddonFilelist = nil;