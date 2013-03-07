#encoding: utf-8
require 'sinatra'
require 'weixin/middleware'
require 'weixin/model'

use Weixin::Middleware, 'your api token', '/your_app_root' 

configure do
    set :wx_id, 'your_weixin_account'
set :public_folder, File.dirname(__FILE__) + '/bootstrap'
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

get '/your_app_root' do
    params[:echostr]
end

get '/' do
 erb :index
end
post '/your_app_root' do
    content_type :xml, 'charset' => 'utf-8'

    message = request.env[Weixin::Middleware::WEIXIN_MSG]
    logger.info "message: #{request.env[Weixin::Middleware::WEIXIN_MSG_RAW]}"

    from = message.FromUserName
    if message.class == Weixin::TextMessage
        content = message.Content
        if content == 'Hello2BizUser'
            reply_msg_content = ".....#{reply_msg_content}"
        end
    end

    create_message(settings.wx_id, from, 'text', reply_msg_content)
end


