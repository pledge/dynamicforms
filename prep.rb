require 'rubygems'
require 'sequel'
require 'logger'

DB = Sequel.sqlite 'target/forms.db', :loggers => [Logger.new($stdout)]

DB.drop_table :form if DB.table_exists? :form
DB.create_table :form do
	primary_key :ID
	String :Name, :size => 50
end

DB.drop_table :question if DB.table_exists? :question
DB.create_table :question do
	primary_key :ID
	String :Label, :size => 100
	String :QuestionType, :size => 100
	String :DataProvider, :size => 100
end

DB.drop_table :question_group if DB.table_exists? :question_group
DB.create_table :question_group do
	primary_key :ID
	String :Name, :size => 100
	String :Prompt
end

DB.drop_table :question_group_question if DB.table_exists? :question_group_question
DB.create_table :question_group_question do
	primary_key :ID
	Integer :FK_QuestionGroupID
	Integer :FK_QuestionID
	Integer :OrderIndex #was tinyint
	#unique key for OrderIndex
end	

DB.drop_table :form_question_group if DB.table_exists? :form_question_group
DB.create_table :form_question_group do
	primary_key :ID
	Integer :FK_FormID
	Integer :FK_QuestionGroupID
	Integer :OrderIndex #was tinyint
	# unique key for OrderIndex
end


ds = DB[:form]
ds.insert(:Name => 'My First Form')
ds.insert(:Name => 'Just Personal Details')
ds.insert(:Name => 'Just about your car')

ds = DB[:question]
ds.insert(:Label => 'Forename', :QuestionType => 'text')
ds.insert(:Label => 'Surname', :QuestionType => 'text')
ds.insert(:Label => 'Gender', :QuestionType => 'radio', :DataProvider => 'Male;Female')
ds.insert(:Label => 'Model', :QuestionType => 'text')
ds.insert(:Label => 'Engine Size', :QuestionType => 'select', :DataProvider => 'Small;Medium;Large')

ds = DB[:question_group]
ds.insert(:Name => 'Personal Details', :Prompt => 'Please answer these questions about your personal details')
ds.insert(:Name => 'Car Details', :Prompt => 'We need to know more about your car')

ds = DB[:question_group_question]
ds.insert(:FK_QuestionGroupID => 1, :FK_QuestionID => 1, :OrderIndex => 1)
ds.insert(:FK_QuestionGroupID => 1, :FK_QuestionID => 2, :OrderIndex => 2)
ds.insert(:FK_QuestionGroupID => 1, :FK_QuestionID => 3, :OrderIndex => 3)
ds.insert(:FK_QuestionGroupID => 2, :FK_QuestionID => 4, :OrderIndex => 1)
ds.insert(:FK_QuestionGroupID => 2, :FK_QuestionID => 5, :OrderIndex => 2)

ds = DB[:form_question_group]
ds.insert(:FK_FormID => 1, :FK_QuestionGroupID => 1, :OrderIndex => 1)
ds.insert(:FK_FormID => 1, :FK_QuestionGroupID => 2, :OrderIndex => 2)
ds.insert(:FK_FormID => 2, :FK_QuestionGroupID => 1, :OrderIndex => 1)
ds.insert(:FK_FormID => 3, :FK_QuestionGroupID => 1, :OrderIndex => 1)

