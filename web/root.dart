part of ld29;

class Root {
  
  static const num POINT_DISTANCE = 20;

  Root parent;
  Point fork;
  List<Point<num>> points;
  num angle;
  num length;
  num target;
  List<Root> subroots;
  Hittable hittable;
  
  Root(this.parent, this.fork, this.angle, this.target) {
    points = new List<Point<num>>();
    points.add(new Point<num>(fork.x, fork.y));
    points.add(new Point<num>(fork.x + sin(angle) * POINT_DISTANCE, fork.y + cos(angle) * POINT_DISTANCE));
    length = POINT_DISTANCE;
    subroots = new List<Root>();
    hittable = null;
  }
  
  /**
   * returns itself or a subroot which has a point close to the given coordinates
   * returns null if no such point is found in itself or the subroots
   * (recursive)
   */
  Root getRootWhichHasPointAround(num x, num y) {
    for (int i = 0; i < points.length; i++) {
      if ((points[i].x - x).abs() < 10 && (points[i].y - y).abs() < 10) {
        return this;
      }
    }
    for (int i = 0; i < subroots.length; i++) {
      Root s = subroots[i].getRootWhichHasPointAround(x, y);
      if (s != null) {
        return s;
      }
    }
    return null;
  }
  
  Point getPointAround(num x, num y) {
    for (int i = 0; i < points.length; i++) {
      if ((points[i].x - x).abs() < 10 && (points[i].y - y).abs() < 10) {
        return points[i];
      }
    }
    return null;
  }
  
  /**
   * returns a level'th subroot of the root
   * returns null if no subroot found
   * (recursive)
   */
  Root getSubroot(int level) {
    if (level == 0) {
      return this;
    }
    for (int i = 0; i < subroots.length; i++) {
      int j = random.nextInt(subroots.length);
      Root s = subroots[j].getSubroot(level - 1);
      if (s != null) {
        return s;
      }
    }
    return null;
  }
  
  /**
   * adds one point to the root and all its subroots if there is enough water and their target length hasn't been reached yet
   */
  void grow() {
    if (length < target && waterSupply > 0) {
      Point l = points[points.length - 1];
      points.add(new Point<num>(l.x + sin(angle) * POINT_DISTANCE, l.y + cos(angle) * POINT_DISTANCE));
      length += POINT_DISTANCE;
      waterSupply--;
      for (int i = 0; i < hittables.length; i++) {
        if (hittables[i].contains(points[points.length - 1])) {
          hittables[i].hit(this);
          break;
        }
      }
    }
    for (int i = 0; i < subroots.length; i++) {
      subroots[i].grow();
    }
  }
  
  void removeFromPoint(int point) {
    disconnect();
    for (int i = points.length - 1; i >= point; i--) {
      for (int j = 0; j < subroots.length; j++) {
        if (points[i] == subroots[j].fork) {
          subroots[j].disconnect();
          subroots.removeAt(j);
          j--;
        }
      }
      points.removeLast();
      length -= POINT_DISTANCE;
    }
    target = length;
    if (points.length <= 1) {
      parent.subroots.remove(this);
    }
  }
  
  /**
   * adds a subroot if there is enough water in supply
   */
  void addSubroot(Root sub) {
    if (waterSupply > 0) {
      subroots.add(sub);
    }
  }
  
  /**
   * disconnect the lakes from the root and all its subroots
   */
  void disconnect() {
    if (hittable != null) {
      hittable.connected = false;
      hittable = null;
    }
    for (int i = 0; i < subroots.length; i++) {
      subroots[i].disconnect();
    }
  }
  
  /**
   * draws the root and all its subroots to the buffer
   */
  void draw(num thickness) {
    if (points.length > 1) {
      buffer.beginPath();
      buffer.moveTo(getXOnCanvas(points[0].x), getYOnCanvas(points[0].y));
      for (int i = 1; i < points.length; i++) {
        buffer.lineTo(getXOnCanvas(points[i].x), getYOnCanvas(points[i].y));
      }
      buffer.lineWidth = (thickness + 20) * worldScale;
      buffer.lineCap = 'round';
      buffer.lineJoin = 'round';
      buffer.strokeStyle = '#883300';
      buffer.stroke();
    }
    for (int i = 0; i < subroots.length; i++) {
      subroots[i].draw(thickness * 0.6);
    }
  }
  
}