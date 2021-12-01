<template>
  <div class="home">
    <el-container>
      <el-main>
        <el-row :gutter="20">
          <el-col :span="18" :offset="3">
            <el-tabs type="border-card" v-model="activeName">
              <el-tab-pane label="分析" name="first">
                <div v-if="active == 1">
                  <el-card class="box-card">
                    <div slot="header" class="clearfix">
                      <span>文件上传</span>
                      <el-button
                        style="float: right; padding: 3px 0"
                        type="text"
                        @click="next"
                        >下一步</el-button
                      ></div>
                    <el-button @click="tips">点击查看Tips</el-button>
                    <el-upload
                      class="upload-demo"
                      drag
                      action="http://localhost:5000/api/upload/file"
                      :on-success="uploadedFile"
                      :limit="1"
                      :on-error="upErr"
                      :on-exceed="limit"
                      name="file"
                      :file-list="fileList"
                      :on-remove="remove"
                    >
                      <i class="el-icon-upload"></i>
                      <div class="el-upload__text">
                        将文件拖到此处，或<em>点击上传</em>
                      </div>
                    </el-upload>
                  </el-card>
                </div>
                <div v-if="active == 2">
                  <el-card class="box-card">
                    <div slot="header" class="clearfix">
                      <span>上传代码</span>
                      <el-button
                        style="float: right; padding: 3px 0; margin: 0px 5px"
                        type="text"
                        @click="analysis"
                        >分析结果</el-button
                      >
                      <el-button
                        style="float: right; padding: 3px 0"
                        type="text"
                        @click="pre"
                        >上一步</el-button
                      >
                    </div>
                    <el-button @click="tips1">点击查看Tips</el-button>
                    <el-select
                      v-model="langvalue"
                      placeholder="请选择"
                      class="langselect"
                    >
                      <el-option
                        v-for="item in options"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value"
                      >
                      </el-option>
                    </el-select>
                    <el-row :gutter="20" class="inputFile">
                      <el-col :span="10">
                        <el-input
                          v-model="inputName"
                          placeholder="请输入要分析的结果文件名"
                        ></el-input>
                      </el-col>
                    </el-row>
                    <el-upload
                      class="upload-demo"
                      drag
                      action="http://localhost:5000/api/upload/code"
                      :on-success="uploadedCode"
                      :limit="1"
                      :on-error="upErr"
                      :on-exceed="limit"
                      name="code"
                      :file-list="fileList1"
                      :on-remove="remove"
                    >
                      <i class="el-icon-upload"></i>
                      <div class="el-upload__text">
                        将文件拖到此处，或<em>点击上传</em>
                      </div>
                    </el-upload>
                  </el-card>
                </div>
                <div v-if="active == 3">
                  <el-card class="box-card">
                    <div slot="header" class="clearfix">
                      <span class="chartsType">图表类型</span>
                      <el-button
                        style="float: right; padding: 3px 0"
                        type="text"
                        @click="visualization"
                        >可视化</el-button
                      >
                      <el-button
                        style="float: right; padding: 3px 0; margin: 0 5px"
                        type="text"
                        @click="pre"
                        >上一步</el-button
                      >
                      <el-select v-model="chartType" placeholder="请选择">
                        <el-option
                          v-for="item in chart"
                          :key="item.value"
                          :label="item.label"
                          :value="item.value"
                        >
                        </el-option>
                      </el-select>
                      <el-button plain @click="open1" style="margin: 0 5px">
                        温馨提示
                      </el-button>
                    </div>
                    <el-table :data="resultsArr" style="width: 100%">
                      <el-table-column
                        v-for="i in lengthArr"
                        :key="i.index"
                        :prop="i"
                        width="150"
                      >
                      </el-table-column>
                    </el-table>
                  </el-card>
                </div>
                <div v-if="active == 4">
                  <el-card class="box-card-select">
                    <div slot="header" class="clearfix">
                      <el-button
                        style="float: right; padding: 3px 0"
                        type="text"
                        @click="pre"
                        >上一步</el-button
                      >
                    </div>
                    <div>请问你想让那一列数据做 x 轴的数据</div>
                    <el-input
                      v-model="lineBarX"
                      placeholder="请输入内容"
                    ></el-input>
                    <div>请问你想让那一列数据做 y 轴的数据</div>
                    <el-input
                      v-model="lineBarY"
                      placeholder="请输入内容"
                    ></el-input>
                    <el-button type="success" @click="next">确定</el-button>
                  </el-card>
                </div>
                <div v-if="active == 6">
                  <visualization
                    :resultsArr="resultsArr"
                    :chartType="chartType"
                    :lineBarX="lineBarX"
                    :lineBarY="lineBarY"
                    :filename="filename"
                    @pre="pre"
                    @Again="Again"
                    :deleteData="deleteData"
                  ></visualization>
                </div>
                <div v-if="active == 5">
                  <el-card class="box-card-select">
                    <div slot="header" class="clearfix">
                      <el-button
                        style="float: right; padding: 3px 0"
                        type="text"
                        @click="pre"
                        >上一步</el-button
                      >
                    </div>
                    <div>你想去掉那一行数据,如果要去掉多行请以英文 "," 分割</div>
                    <el-input
                      v-model="deleteData"
                      placeholder="请输入行号"
                    ></el-input>
                    <el-button type="success" @click="result">确定</el-button>
                  </el-card>
                </div>
              </el-tab-pane>
              <el-tab-pane label="关于" name="second">
                <el-collapse v-model="activeCollapse" >
                  <el-collapse-item title="软件介绍" name="1">
                    <div>本软件的开发运用了Vue，node.js，express，electron等技术，软件可以让用户自定义上传的代码及处理文件，使用起来很方便，用户可以上传perl，python，jave等语言的代码来处理自己的文件，最后用户可以将处理的结果以图表的形式展示出来</div>
                  </el-collapse-item>
                  <el-collapse-item title="软件应用技术介绍" name="2">
                    <el-divider content-position="left">Vue</el-divider>
                    <div>Vue (读音 /vju:/，类似于 view) 是一套用于构建用户界面的渐进式框架。与其它大型框架不同的是，Vue 被设计为可以自底向上逐层应用。Vue 的核心库只关注视图层，不仅易于上手，还便于与第三方库或既有项目整合。另一方面，当与现代化的工具链以及各种支持类库结合使用时，Vue 也完全能够为复杂的单页应用提供驱动。</div>
                    <el-divider content-position="left">Node.js</el-divider>
                    <div>Node.js发布于2009年5月，由Ryan Dahl开发，是一个基于Chrome V8引擎的JavaScript运行环境，使用了一个事件驱动、非阻塞式I/O模型，让JavaScript 运行在服务端的开发平台，它让JavaScript成为与PHP、Python、Perl、Ruby等服务端语言平起平坐的脚本语言。</div>
                    <el-divider content-position="left">Express</el-divider>
                    <div>Express 是一个保持最小规模的灵活的 Node.js Web 应用程序开发框架，为 Web 和移动应用程序提供一组强大的功能。</div>
                    <el-divider content-position="left">Electron</el-divider>
                    <div>Electron 是一个使用 JavaScript、HTML 和 CSS 构建桌面应用程序的框架。通过将Chromium和Node.js嵌入其二进制文件中，Electron 允许您维护一个 JavaScript 代码库并创建可在 Windows、macOS 和 Linux 上运行的跨平台应用程序——无需本地开发经验。</div>
                  </el-collapse-item>
                  <el-collapse-item title="软件使用手册" name="3">
                    <el-divider content-position="left">处理文件</el-divider>
                    <div>处理文件需用户自己上传，上传的文件默认储存在电脑C盘下面</div>
                    <el-divider content-position="left">处理代码</el-divider>
                    <div>处理文件的代码需要用户自己上传，确保代码正确，处理的结果需要输出成一个文件，且输出文件需要与处理文件在相同的目录下，处理文件的内容需要以制表符进行分隔</div>
                    <el-divider content-position="left">结果文件</el-divider>
                    <div>结果文件需要用户自己输入文件名，也就是要展示的文件</div>
                    <el-divider content-position="left">图表</el-divider>
                    <div>结果展示需要展示成图表，用户可以自己选择要展示的类型，请选择正确适合的类型，否则将导致图标无法进行展示</div>
                    <el-divider content-position="left">展示的图标可以动态的展示，用户可以任意添加或删除不想要的数据，展示的图可以保存到本地</el-divider>
                  </el-collapse-item>
                  <el-collapse-item title="示例代码以及示例文件">
                    <div>示例代码及文件可以在软件安装目录中的找到</div>
                  </el-collapse-item>
                  <el-collapse-item title="联系我们" name="4">
                    <div>如果你在使用过程中发现任何的不足之处,请来联系我们</div>
                    <div>联系邮箱:2179607451@qq.com</div>
                  </el-collapse-item>
                </el-collapse>
              </el-tab-pane>
            </el-tabs>
          </el-col>
        </el-row>
      </el-main>
    </el-container>
  </div>
</template>

<script>
import { getResults } from "../network/api";
import Visualization from "../components/visualization";
export default {
  name: "Home",
  components: { Visualization },
  data() {
    return {
      active: 1,
      activeName: "first",
      activeCollapse:"1",
      options: [
        {
          value: "python",
          label: "python",
        },
        {
          value: "perl",
          label: "perl",
        },
        {
          value: "java",
          label: "java",
        },
      ],
      chart: [
        {
          value: "折线图",
          label: "折线图",
        },
        {
          value: "柱状图",
          label: "柱状图",
        },
        {
          value: "饼状图",
          label: "饼状图",
        },
        {
          value: "表格",
          label: "表格",
        },
        {
          value: "散点图",
          label: "散点图",
        },
      ],
      langvalue: "",
      fileList: [],
      fileList1: [],
      filename: "",
      codename: "",
      resultsArr: [],
      lengthArr: [],
      inputName: "",
      chartType: "",
      lineBarX: "",
      lineBarY: "",
      deleteData: "",
    };
  },
  computed: {},
  methods: {
    tips() {
      this.$alert(
        "这一步用户需要自己上传需要处理的文件,文件可以说任意格式,如35823.fasta",
        "操作提示",
        {
          confirmButtonText: "确定",
          callback: (action) => {
            this.$message({
              type: "success",
              message: `已关闭提示`,
            });
          },
        }
      );
    },
    tips1() {
      this.$alert(
        "这一步用户需要自己上传处理文件的代码,并且需要在右侧选中相应的语言,本软件目前支持上传 python，perl，java等语言的代码",
        "操作提示",
        {
          confirmButtonText: "确定",
          callback: (action) => {
            this.$message({
              type: "success",
              message: `已关闭提示`,
            });
          },
        }
      );
    },
    next() {
      this.active++;
    },
    open1() {
      const h = this.$createElement;
      this.$notify({
        title: "温馨提示",
        message: h(
          "i",
          { style: "color: teal" },
          "请选择想展示的数据对应的图表类型,不适合的图表将无法展示,在删除第几行数据时会在原始数据上改变,也就是说第一次删除后不用再进行第二次删除"
        ),
      });
    },
    pre() {
      console.log("dia");
      this.active--;
    },
    limit() {
      this.$message({
        message: "上传个数超过最大限制",
        type: "warning",
      });
    },
    upErr() {
      this.$message.error("上传失败");
    },
    uploadedFile(response, file) {
      console.log(response);
      console.log(file);
      this.filename = response.Filename;
    },
    uploadedCode(response, file) {
      console.log(response);
      console.log(file);
      this.codename = response.Codename;
    },
    remove() {
      this.$message({
        message: "文件移除成功",
        type: "success",
      });
    },
    analysis() {
      if (this.langvalue != "" && this.inputName != "") {
        const h = this.$createElement;
        this.$msgbox({
          title: "分析提示",
          message: h("p", null, [
            h("span", null, "点击确定进行分析"),
            h("i", { style: "color: teal" }),
          ]),
          showCancelButton: true,
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          beforeClose: (action, instance, done) => {
            if (action === "confirm") {
              instance.confirmButtonLoading = true;
              instance.confirmButtonText = "分析中...";
              getResults({
                lang: this.langvalue,
                filename: this.filename,
                codename: this.codename,
                inputName: this.inputName,
              }).then((res) => {
                console.log(res);
                if (res.data.msg == "ok") {
                  instance.confirmButtonLoading = false;
                  instance.confirmButtonText = "确定";
                  this.resultsArr = res.data.resultsArr;
                  this.active = 3;
                  for (let i = 0; i < this.resultsArr[1].length; i++) {
                    this.lengthArr.push(`${i}`);
                  }
                  done();
                }
              });
            } else {
              done();
              instance.confirmButtonLoading = false;
              instance.confirmButtonText = "确定";
            }
          },
        }).then((action) => {
          this.$message({
            type: "success",
            message: "分析成功",
          });
        });
      } else {
        this.$message({
          showClose: true,
          message: "警告,语言或要输出的文件名而空",
          type: "warning",
        });
      }
    },
    result() {
      this.active = 6;
    },
    visualization() {
      if (this.chartType == "") {
        this.$message({
          message: "警告，图形类型为空",
          type: "warning",
        });
      } else {
        if (
          this.chartType == "折线图" ||
          this.chartType == "柱状图" ||
          this.chartType == "散点图"
        ) {
          this.active = 4;
        }
        if (this.chartType == "饼状图" || this.chartType == "表格") {
          this.active = 5;
        }
      }
    },
    Again(){
      this.active=1
      langvalue: ""
      fileList: []
      fileList1: []
      filename: ""
      codename: ""
      resultsArr: []
      lengthArr: []
      inputName: ""
      chartType: ""
      lineBarX: ""
      lineBarY: ""
      deleteData: ""
    }
  },
};
</script>
<style scoped lang='less'>
.el-main {
  background-color: #f8f5f5;
  padding: 100px 0px;
  .upload-demo {
    margin-top: 30px;
  }
  .langselect {
    margin-left: 10px;
  }
}
.el-main::-webkit-scrollbar {
  display: none;
}
.home {
  width: 100%;
  height: 100%;
}
.el-container {
  width: 100%;
  height: 100%;
}
.inputFile {
  margin-top: 10px;
}
.chartsType {
  margin-right: 10px;
}
.box-card-select {
  div {
    margin: 15px 0;
  }
  .el-input {
    width: 40%;
  }
  .el-button {
    display: block;
  }
}
</style>
