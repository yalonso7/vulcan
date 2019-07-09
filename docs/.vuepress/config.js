module.exports = {
  themeConfig: {
    repo: "mitre/vulcan",
    repoLabel: "Add to our project!",
    sidebar: "auto",
    nav: [
      { text: "Home", link: "/" },
      { text: "Get Started", link: "/getStarted/" },
      { text: "About Vulcan", link: "/why/" },
      {
        text: "Install",
        link: "/install/",
        items: [
          { text: "Developers", link: "/install/developers/" },
          { text: "Deployers", link: "/install/deployers/" }
        ]
      },
      { text: "Documents", link: "/documents/" },
      { text: "Developers", link: "/developers/" },

      { text: "Check out the demo", link: "http://xk3r.hatchboxapp.com/" }
    ]
  },
  logo: "./black-letter-v.png",
  title: " ",
  description:
    "Streamlining tool for creating STIGs and InSpec security compliance profiles"
};
