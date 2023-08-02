function chat.RequestChatTag(id)
    net.Start 'ba::chat.SetTag'
        net.WriteString(id)
    net.SendToServer()
end

function chat.RequestClearChatTag()
    net.Start 'ba::chat.ClearTag'
    net.SendToServer()
end