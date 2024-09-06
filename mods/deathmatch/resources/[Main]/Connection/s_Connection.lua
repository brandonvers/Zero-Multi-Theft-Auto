
function DatabaseConnection()
    connection = dbConnect(get("databaseType"),"charset="..get("mysql_charset")..";dbname="..get("mysql_dbname")..";host="..get("mysql_host")..";port="..(get("mysql_port") or 3306), get("mysql_username"), get("mysql_password"), "tag="..get("mysql_tag")..";log="..get("mysql_log")..";autoreconnect="..get("mysql_autoreconnect")..";share="..get("mysql_share")..";multi_statements="..get("mysql_multi_statements"));
    if not connection then
        setTimer(DatabaseConnection, 1000, 1);
        outputDebugString("[MYSQL] Connection failed!", 4, 255, 0, 0);
        return false;
    else
        outputDebugString("[MYSQL] Connection successful! ("..get("mysql_dbname").."-Database)", 4, 0, 255, 0);
    end
end
addEventHandler("onResourceStart", resourceRoot, DatabaseConnection);

function DestroyConnect()
    if isElement(connection) then
		destroyElement(connection);
        outputDebugString("[MYSQL] The Mysql has stopped", 4, 255, 0, 0);
        shutdown("[MYSQL] Megszakadt a kapcsolat az adatbazissal.")
	end
end
addEventHandler("onResourceStop", resourceRoot, DestroyConnect);

function getConnection(res)
    local resName = getResourceName(res);
    if resName then
        outputDebugString("[MYSQL] Connection requested by resource: "..resName.."!", 4, 0, 255, 0);
	    return connection;
    end
end
