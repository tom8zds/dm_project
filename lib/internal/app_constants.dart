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
