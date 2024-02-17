import Hash "mo:base/Hash";
import Map "mo:base/HashMap";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

// To do project

actor Assistant{
  // public query func greet(name : Text) : async Text {
  //   return "Hello, " # name # "!";
  // };

  type ToDo = {
    description: Text;
    completed: Bool;
  };

  // HashMap
  func natHash(n: Nat) : Hash.Hash {
    Text.hash(Nat.toText(n))
  };

  // let immutable declare olur
  // var mutable
  var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);
  var nextId : Nat = 0;

  public query func getTodos(): async [ToDo] {
    Iter.toArray(todos.vals());
  };

  //ID todo atamasi - sorgu ve tanimlama
  public query func addTodo(description: Text) : async Nat {
    let id = nextId;
    todos.put(id, {description = description; completed = false});
    nextId += 1;
    id
  };

  // update atamasi
  public func completeTodo(id: Nat): async () {
    ignore do ? {
      let description = todos.get(id)!.description;
      todos.put(id, {description; completed = true});
    }
  };

  public query func showTodos() : async Text {
    var output: Text = "\n___TO_DOS___\n";
    for (todo: ToDo in todos.vals()) {
      output #= "/n" # todo.description;
      if (todo.completed) {output #= " +";};
    };
    output # "/n"
  };

  public func clearCompleted() : async () {
    todos := Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal, natHash,
    func(_, todo) {if (todo.completed) null else ?todo});
  };
  
};
