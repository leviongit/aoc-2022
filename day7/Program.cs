using System.Collections;

namespace day7;

internal class File {
  public readonly string Name;


  public File(string name, int size) {
    Name = name;
    Size = size;
  }

  public int Size { get; }
}

internal class Directory : File, IEnumerable<File> {
  public readonly List<File> Children;
  public readonly Directory? Parent;

  public Directory(string name, Directory? parent) : base(name, 0) {
    Parent = parent;
    Children = new List<File>();
  }

  public new int Size => Children.Sum(file => file is Directory dir ? dir.Size : file.Size);


  public IEnumerator<File> GetEnumerator() {
    yield return this;
    foreach (var child in Children)
      if (child is Directory directory)
        foreach (var grandchild in directory)
          yield return grandchild;
      else
        yield return child;
  }

  IEnumerator IEnumerable.GetEnumerator() {
    return GetEnumerator();
  }

  public IEnumerator<Directory> DirWalkEnumerator() {
    yield return this;
    foreach (var child in Children) {
      if (child is not Directory directory) continue;
      var enumerator = directory.DirWalkEnumerator();
      while (enumerator.MoveNext()) yield return enumerator.Current;
    }
  }
}

internal static class Solution {
  private static List<T> ListOfEnumerator<T>(IEnumerator<T> enumerator) {
    var list = new List<T>();
    while (enumerator.MoveNext()) list.Add(enumerator.Current);
    return list;
  }

  private static void P1(Directory root) {
    var list = ListOfEnumerator(root.DirWalkEnumerator());

    Console.Out.WriteLine(list.FindAll(file => file.Size < 100_000).Sum(file => file.Size));
  }

  public static void Main() {
    var currentDirectory = new Directory("/", null) ?? throw new Exception();
    var root = currentDirectory;
    var input = System.IO.File.ReadAllLines("in.txt");
    foreach (var ln in input)
      if (ln.StartsWith('$')) {
        var command = ln.Substring(2).Split(' ');
        switch (command[0]) {
          case "cd": {
            currentDirectory = command[1] switch {
              "/" => root,
              ".." => currentDirectory!.Parent ?? currentDirectory,
              _ => currentDirectory!.Children.Find(file => file.Name == command[1]) as Directory
            };

            break;
          }
          case "ls": {
            break; // noop
          }
        }
      }
      else {
        var output = ln.Split(' ');
        currentDirectory!.Children.Add(output[0] == "dir"
          ? new Directory(output[1], currentDirectory)
          : new File(output[1], int.Parse(output[0])));
      }

    P1(root);
  }
}