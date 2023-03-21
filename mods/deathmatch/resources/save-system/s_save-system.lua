local mysql = exports.Connection;
local database = mysql:getConnection(getThisResource());


function savePlayer(reason, player)
    local playing = getElementData(source, "isPlaying");
    if (playing) then
        local x, y, z = getElementPosition(source);
        local rot = getPedRotation(source);
        local health = getElementHealth(source);
        local interior = getElementInterior(source);
        local dimension = getElementDimension(source);
        local location = getElementZoneName (source);

        dbExec(database, "UPDATE characters SET x=?, y=?, z=?, rotation=?, health=?, dimension=?, interior=?, lastlogin=NOW(), lastarea=?, WHERE id=?", x, y, z, rot, healt, dimension, interior, location, getElementData(client, "acc:charid"));
    end
end
addEventHandler("onPlayerQuit", getRootElement(), savePlayer)
addEvent("savePlayer", false)
addEventHandler("savePlayer", getRootElement(), savePlayer)

addCommandHandler("save", savePlayer)