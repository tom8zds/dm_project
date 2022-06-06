const String settingBoxKey = "setting";
const String comicApiBoxKey = "comicApiBox";
const String comicMissionBoxKey = "missionBox";
const String localComicBoxKey = "localComic";

const List<String> initBoxes = [
  settingBoxKey,
  comicApiBoxKey,
  comicMissionBoxKey,
  localComicBoxKey,
];

const themeColors = [
  0xff6750a4,
  0xFFF44336,
  0xFF2196F3,
  0xFFFCC9B9,
];

const themeColorNames = [
  "质感基准",
  "根正苗红",
  "海天一色",
  "樱",
];

const imgHeader = {"Referer": "http://www.dmzj.com/"};
const firstChunkSize = 102;
// 4M
const chunkSize = 4194304;
const downloadHeader = {
  "Referer": "http://images.muwai.com/",
  "Host": "imgzip.muwai.com",
  "Connection": "Keep-Alive",
  "Accept-Encoding": "gzip",
  "User-Agent": "okhttp/3.12.1",
};
