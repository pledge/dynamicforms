require 'rubygems'
require 'sinatra'
require 'sequel'
require 'logger'

# Configuration

#DB = Sequel.connect('mysql://root:@127.0.0.1/refinery2',
#	:logger => Logger.new('log/db.log')
#)
DB = Sequel.sqlite 'target/forms.db', :loggers => [Logger.new($stdout)]

configure do
end

not_found do 
	"Page not found"
end

error do
	"Oops, show the whale"
end

# Routes

get '/forms' do
	end

get '/form/:id' do

	form_id = params[:id]

	form = DB[:form].filter(:ID => form_id).first

	question_groups = DB[:form_question_group].join(:question_group, :ID => :FK_QuestionGroupID).filter(:FK_FormID => form_id).
		order_by(:OrderIndex).all

	questions_hash = Hash.new
	question_group_hash = Hash.new
	question_groups.each do | qg |
		
		question_group_id = qg[:ID]
		questions = DB[:question_group_question].filter(:FK_QuestionGroupID => question_group_id ).order_by(:OrderIndex).all
		question_group_hash[question_group_id] = questions

		questions.each do | q |
			question_id = q[:ID]
			question = DB[:question].filter(:ID => question_id).first
			question[:rendered] = render_question(question)
			questions_hash[question_id] = question
		end

	end

	haml :form, :locals => {:form => form, :question_groups => question_groups, 
		:question_group_questions => question_group_hash,
		:questions => questions_hash }
end

get '/*' do
	forms = DB[:form].order(:ID).all
	haml :index, :locals => {:forms => forms}
end

def render_question(question)

	case question[:QuestionType]
	when 'text'
		haml :text, :layout => false, :locals => {:qid => question[:ID]}
	when 'select'
		haml :select, :layout => false, :locals => {:qid => question[:ID], :options => translate_options(question[:DataProvider])}
	when 'radio'
		haml :radio, :layout => false, :locals => {:qid => question[:ID], :options => translate_options(question[:DataProvider])}
	end
end

def translate_options(ops)
	ops.split(";")
end


