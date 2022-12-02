import sys.io.File;

// this is the first time i ever touched haxe, this may be awful code, but it works, so whatever
class Main {
	static var points = [3, 0, 6, 6, 3, 0, 0, 6, 3];

	static var move = ["Z", "X", "Y", "X", "Y", "Z", "Y", "Z", "X"];

	static function getPoints(enemyChoice:String, playerChoice:String):Int {
		return points[
			enemyChoice.charCodeAt(0) - "A".code + (playerChoice.charCodeAt(0) - "X".code) * 3
		] + (playerChoice.charCodeAt(0) - "X".code) + 1;
	}

	static function doMove(enemyChoice:String, hint:String) {
		return getPoints(enemyChoice, move[enemyChoice.charCodeAt(0) - "A".code + (hint.charCodeAt(0) - "X".code) * 3]);
	}

	#if !dbg
	static var file = "in.txt";
	#else
	static var file = "in.dbg.text";
	#end

	static public function p1() {
		var f = File.read(file);

		var acc = 0;
		var lns = StringTools.trim(f.readAll().toString()).split("\n");

		for (ln in lns) {
			var choices = ln.split(" ");
			var pts = getPoints(choices[0], choices[1]);
			acc += pts;
		}

		trace(acc);

		f.close();
	}

	static public function p2() {
		var f = File.read(file);

		var acc = 0;
		var lns = StringTools.trim(f.readAll().toString()).split("\n");

		for (ln in lns) {
			var choices = ln.split(" ");
			var pts = doMove(choices[0], choices[1]);
			acc += pts;
		}

		trace(acc);

		f.close();
	}

	static public function main():Void {
		p1();
		trace("\n");
		p2();
	}
}
