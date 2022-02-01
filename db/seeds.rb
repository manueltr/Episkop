# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create(username: "testUser1", email: "test@email.test", firstname: "test", uid: "test", provider: "google")
User.create(username: "testUser2", email: "test@email.test", firstname: "test", uid: "test1")
User.create(username: "testUser3", email: "test@email.test", firstname: "test", uid: "test2")
