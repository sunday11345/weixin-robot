#encoding: utf-8
require 'sinatra'
require 'weixin/middleware'
require 'weixin/model'


use Weixin::Middleware, 'your_token', '/' 

configure do
    set :wx_id, 'your_id'
end

helpers do

    def create_message(from, to, type, content, flag=0)
        msg = Weixin::TextReplyMessage.new
        msg.ToUserName = to
        msg.FromUserName = from
        msg.Content = content
        msg.to_xml
    end
end

get '/' do
    params[:echostr]
end


post '/' do
    content_type :xml, 'charset' => 'utf-8'

    message = request.env[Weixin::Middleware::WEIXIN_MSG]
    logger.info "message: #{request.env[Weixin::Middleware::WEIXIN_MSG_RAW]}"

    from = message.FromUserName
    if message.class == Weixin::TextMessage
        content = message.Content
        if content == 'Hello2BizUser'
            reply_msg_content = "Thx, #{reply_msg_content}"
        end
    end

    create_message(settings.wx_id, from, 'text', reply_msg_content)
end



