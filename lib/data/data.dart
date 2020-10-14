class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc("View Recipes Shared By Users across the world");
  sliderModel.setTitle("VARIOUS RECIPES");
  sliderModel.setImageAssetPath(
      "https://dcassetcdn.com/design_img/10150/1674/1674_298052_10150_thumbnail.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc("Share your recipes with the world!");
  sliderModel.setTitle("SHARE");
  sliderModel.setImageAssetPath(
      "https://mir-s3-cdn-cf.behance.net/projects/404/d407e298634635.Y3JvcCwxMTkyLDkzMywxMDMsMA.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
