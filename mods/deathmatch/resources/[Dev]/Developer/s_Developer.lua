local mysql = exports.Connection;
local database = mysql:getConnection(getThisResource());


function CreateDeveloper(thePlayer, cmd,  name)
    local qh = dbQuery(database, "SELECT name FROM developer WHERE Name=? ", name);
    local data = dbPoll(qh, 500);
    if (data) then
        if (#data == 0) then
            dbExec(database, "INSERT INTO developer SET Name=?, serial=?", name, getPlayerSerial(thePlayer));
            outputChatBox("[Dev] Sikeresen letrehoztad a fejleszto fiokjat!", thePlayer);
            outputDebugString("[Dev] "..name.." letrehozott egy uj fejlesztoi profilt!", 4, 255, 165, 0);
        else
            outputChatBox("[Dev] Ez a nev mar letezik",thePlayer, 255, 0, 0 );
        end
    end
end
addCommandHandler("createdeveloper", CreateDeveloper);


function RemoveDeveloper(thePlayer, cmd,  name, localname)
    local qh = dbQuery(database, "SELECT name FROM developer WHERE Name=? ", name);
    local data = dbPoll(qh, 500);
    local localname = getPlayerName(thePlayer);
    if (data) then
        if (#data == 1) then
            dbExec(database, "DELETE FROM developer WHERE Name=?", name);
            outputChatBox("[Dev] Sikeresen kitorolted a fejleszto fiokjat!", thePlayer);
            outputDebugString("[Dev] "..localname.." kitorolte "..name.." fejlesztoi profiljat!", 4, 255, 0, 0);
        else
            outputChatBox("[Dev] Ez a nev mar nem letezik",thePlayer, 255, 0, 0 );
        end
    end
end
addCommandHandler("removedeveloper", RemoveDeveloper);

