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

